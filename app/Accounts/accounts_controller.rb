require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'
require 'ostruct'
require 'Accounts/account'

class AccountsController < Rho::RhoController
  include BrowserHelper
  def index
    #@accountses = Accounts.find(:all)
    #render :back => '/app'
    @@get_result = ""
    @@parsed="{}"
    @account=""
    Rho::AsyncHttp.post(
      :url => 'https://crm.zoho.com/crm/private/json/Accounts/getMyRecords?authtoken=9a31377e091161d17cab934c1f041f95&scope=crmapi',
            #  :url =>'https://accounts.zoho.com/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&EMAIL_ID=mns.surendran@gmail.com&PASSWORD=smoothkiller',
      :callback => (url_for :action => :httpget_callback),
      :callback_param => "" )
    render  :controller => :Accounts, :action => :wait
  end
     
  def get_res
       @accounts_list=  @@get_result 
    end
   
    def get_error
       @@error_params
    end 
  
  def httpget_callback
       
    if @params['status'] != 'ok'
      @@error_params = @params
      WebView.navigate ( url_for :action => :show_error )        
    else
      parsed = @params['body']
      row =parsed['response']['result']['Accounts']['row']
            #row.each { |x|  Account.new(rd['no'], rd["FL"]) }
      # residents = row.map { |rd|
      # Account.new(rd['no'], rd["FL"]) 
      #}
      # @@get_result=residents[0]
            accounts=row.inject([]) { |o,d| o << Account.new( d['no'], d['FL'] ) }
      @@get_result=accounts
      WebView.navigate ( url_for :action => :show_result )
        end
    end
  
   def show_result
       render :action => :index, :back => '/app'
    end
   
    def show_error
       render :action => :error, :back => '/app'
    end
       
    def cancel_httpcall
      Rho::AsyncHttp.cancel( url_for( :action => :httpget_callback) )
          @@get_result  = 'Request was cancelled.'
      render :action => :index, :back => '/app'
    end
    
    def account_view
       @accounts=get_res()[(@params['id'].to_i)]
       render :action => :account
    end
    
    
  def add_account
   ' <Accounts>
    <row no="1">
    <FL val="Account Name">Zillum</FL>
    <FL val="Website">www.zillum.com</FL>
    <FL val="Employees">200</FL>
    <FL val="Ownership">Private</FL>
    <FL val="Industry">Real estate</FL>
    <FL val="Fax">99999999</FL>
    <FL val="Annual Revenue">20000000</FL>
    </row>
    </Accounts>'
    
    
    Rho::AsyncHttp.post(
          :url => 'https://crm.zoho.com/crm/private/xml/Accounts/insertRecords?authtoken=9a31377e091161d17cab934c1f041f95&scope=crmapi&newFormat=1&xmlData=',
                #  :url =>'https://accounts.zoho.com/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&EMAIL_ID=mns.surendran@gmail.com&PASSWORD=smoothkiller',
          :callback => (url_for :action => :httpget_callback),
          :callback_param => "" )
        render  :controller => :Accounts, :action => :wait
   end
   def add
     render  :controller => :Accounts, :action => :add
   end
    
   def create
   
     Alert.show_popup(@params['name'].to_s())
     
   end
   
  

end
