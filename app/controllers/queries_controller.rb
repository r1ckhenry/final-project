 require 'csv'
 require 'json'

class QueriesController < ApplicationController

  def index
    @accounts = get_accounts_graph
    # @date = Query.get_date_ranges
  end

  def new
    # create a new instance of the Adwords object and access to it's methods
    adwords = get_adwords_api
    # Get the report utils for this report
    report_utils = adwords.report_utils(get_api_version)
    # Report definition
    report_definition =  {
      :selector => {
        :fields => %w(Year MonthOfYear Query MatchType Impressions Clicks Cost ConvertedClicks AccountCurrencyCode)
      },
      :report_name => 'Last 7 days SEARCH_QUERY_PERFORMANCE_REPORT',
      :report_type => 'SEARCH_QUERY_PERFORMANCE_REPORT',
      :download_format => 'CSV',
      :date_range_type => 'LAST_7_DAYS',
      # Enable to get rows with zero impressions.
      :include_zero_impressions => false
    }

    # Download report as file
    data = report_utils.download_report(report_definition)

    @output = CSV.parse(data).to_json

    render json: @output
  end

  def show
  end

  private

  def get_accounts_graph
    adwords = get_adwords_api
    # Lets get the client customer ID
    campaign_srv = adwords.service(:CustomerService, get_api_version)
    customer = campaign_srv.get()

    # Set this customer_id as the credential
    adwords.credential_handler.set_credential(:client_customer_id, customer[:customer_id])

    # Find all the child accounts that are managed
    managed_customer_srv = adwords.service(:ManagedCustomerService, get_api_version)
    # return to us the CustomerId and the CompanyName
    selector = {
      :fields => ['CustomerId', 'CompanyName']
    }
    result = nil
    begin
      result = managed_customer_srv.get(selector)
    rescue AdwordsApi::Errors::ApiException => e
      logger.fatal("Exception occurred: %s\n%s" % [e.to_s, e.message])
      flash.now[:alert] =
          'API request failed with an error, see logs for details'
    end
    return result
  end

end
