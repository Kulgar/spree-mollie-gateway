module Spree::UserDecorator

  def self.prepended(base)
    base.after_commit :ensure_mollie_customer, on: %i[create update]
  end

  def ensure_mollie_customer
    return if try(:mollie_customer_id).present?

    # Don't create Mollie customers if spree_auth_devise is not installed.
    return unless defined? Spree::User

    mollie_gateway = Spree::PaymentMethod.find_by_type 'Spree::Gateway::MollieGateway'
    return unless mollie_gateway&.active?

    mollie_customer = mollie_gateway.create_customer(self)
    update mollie_customer_id: mollie_customer.id
  end
end

Spree.user_class.prepend(Spree::UserDecorator)
