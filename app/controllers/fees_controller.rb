class FeesController < ApplicationController
  def index
    @fees = Fee.paginate(page: params[:page])
    @total_fees = Fee.sum(:amount)
  end

  def new
    @client = Client.find(params[:client_id])
    @fee = Fee.new
  end

  def create
    @client = Client.find(params[:client_id])

    @fee = Fee.new(fee_params)
    @fee.client = @client

    if @fee.save
      flash[:notice] = "Fee added successfully."
      redirect_to manage_fees_path(@client)
    else
      render 'new'
    end
  end

  def manage
    @client = Client.find(params[:client_id])
    @fees = @client.fees.paginate(page: params[:page], per_page: 10)

    @total_fees = @client.fees.sum(:amount)
  end


  private
    def fee_params
      params.require(:fee).permit(:details, :amount)
    end
end