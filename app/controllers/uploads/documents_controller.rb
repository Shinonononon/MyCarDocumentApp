module Uploads
  class DocumentsController < ApplicationController
    before_action :authenticate_employee!

    def index
      @driver_license = current_employee.driver_license
      @vehicle_inspection = current_employee.vehicle_inspection
      @compulsory_insurance = current_employee.compulsory_insurance
      @optional_insurance = current_employee.optional_insurance
    end
  end
end
