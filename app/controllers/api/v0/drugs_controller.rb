class API::V0::DrugsController < API::V0::BaseController
  #----------------------------------------------------------------------------
  # GET /api/v0/drugs
  def show
    matches = Drug.find_by_name(params[:query].downcase.strip)
    rxcuis  = matches.map {|m| m["rxcui"]}

    drugs = []
    rxcuis.each do |rxcui|
      d = Drug.new(rxcui)
      drugs << d.get_all(false)
    end

    render :json => drugs, :status => :ok and return
  end

  #----------------------------------------------------------------------------
  # GET /api/v0/drugs/rxcui?rxcui=...
  def rxcui
    drug = Drug.new(params[:rxcui])
    drug.related()
    drug.get_images()
    render :json => drug, :status => :ok and return
  end
end
