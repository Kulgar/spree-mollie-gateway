module Spree::Api::V1::ShipmentsControllerDecorator
  def ship
    unless @shipment.tracking.present?
      # We should enforce entering tracking details, otherwise shipments cannot
      # be created through Mollie.
      unprocessable_entity('Please fill in your tracking details')
      return
    end
    @shipment.ship! unless @shipment.shipped?
    respond_with(@shipment, default_template: :show)
  end
end

Spree::Api::V1::ShipmentsController.prepend(Spree::Api::V1::ShipmentsControllerDecorator)