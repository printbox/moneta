require File.dirname(__FILE__) + '/spec_helper'

describe 'Moneta' do
  
  context 'get token' do
    
    before(:each) do 
      @terminal = Moneta::Eterminal.new
      @amount = '10.00 EUR'
    end
    
    it 'should call moneta service' do
      @terminal.should_receive(:savon_call).with(:get_token, anything())
      @terminal.token(@amount)
    end
    
    it 'should handle exceptions' do
      @terminal.stub(:moneta_call) { raise "Errror" }
      res = @terminal.token(@amount)
      res[:error_code].should == -1
    end
    
    it 'should return correct status, token and transId on success' do
      @terminal.stub(:savon_call) { {token: '123', transaction_id: '134', error_code: '0', error_description: '', valid_until: '30.12.2011'} }
      res = @terminal.token(@amount)
      res[:token].should == '123'
      res[:transaction_id].should == '134'
      res[:error_code] == "0"
      res[:error_description].should == ''
      res[:valid_until].should == '30.12.2011'
    end
    
    it 'should return error if amount is greather than 1000000 or amount is not of proper format' do
      
    end
    
    it 'should return status, code and msg on failure' do
      Moneta::Eterminal.stub(:savon_call) { raise "Error" }
      res = @terminal.token(@amount)
      res[:error_code].should == -1
      res[:error_description].should_not == ""
    end
  
  end
  
  context 'get transaction status' do
    
    before(:each) do
      @terminal = Moneta::Eterminal.new
      @transaction_id = 12345
    end
    
    it 'should call moneta service' do
      @terminal.should_receive(:savon_call).with(:get_transaction_status, anything())
      @terminal.transaction_status(@transaction_id)
    end
      
    it 'should handle exceptions' do
      @terminal.stub(:savon_call) { raise "Error" }
      res = @terminal.transaction_status(@transaction_id)
      res[:error_code].should == -1
      res[:error_description].should_not be_empty
    end
    
    it 'should return reference_id and status when transaction is completed' do
      @terminal.stub(:savon_call) { {status: '3', reference_id: '1234'} }
      response = @terminal.transaction_status(@transaction_id)
      response[:reference_id].should == '1234'
      response[:status].should == '3'
    end
    
     it 'should return status 13 with description when transaction was unproperly processed by processing center' do
       @terminal.stub(:savon_call) { {status: '13', error_description: 'insufficient funds'} }
       response = @terminal.transaction_status(@transaction_id)
       response[:status].should == '13'
       response[:error_description].should == 'insufficient funds'
     end
      
    it 'should return status for transaction in process' do
      @terminal.stub(:savon_call) { {status: '2', error_code: '0', error_description: '0'} }
      response = @terminal.transaction_status(@transaction_id)
      response[:status].should == '2'
    end
    
    it 'should handle exception' do
      @terminal.stub(:savon_call) { raise 'Exception' }
      response = @terminal.transaction_status(@transaction_id)
      response[:error_code].should == -1
      response[:error_description].should_not be_empty
    end
  end
  
  context 'login' do
    
    before(:each) do
      @terminal = Moneta::Eterminal.new
      @pin = nil
    end
   
     it 'should call moneta service' do
       @terminal.should_receive(:savon_call).with(:log_in, anything())
       @terminal.login(@pin)
     end
    
    it 'should handle exceptions' do
      @terminal.stub(:savon_call) { raise 'Error' }
      res = @terminal.login(@pin)
      res[:error_code].should == -1
      res[:error_description].should == 'Error'
    end
    
    it 'should return customer informations if certificate and pin are correct' do
      @terminal.stub(:savon_call) { {mid: '9011', pid: '527', error_code: "0", customer_name: 'lorem ipsum', name: 'lorem'} }
      response = @terminal.login(@pin)
      response[:name].should == 'lorem'
      response[:error_code].should == "0"
      response[:mid].should == '9011'
      response[:pid].should == '527'
      response[:customer_name].should == 'lorem ipsum'
    end
    
    it 'should return error code with error description if processing center is having difficulties' do
      @terminal.stub(:savon_call) { {error_code: '33', error_description: 'processing center is having problems'}}
      response = @terminal.login(@pin)
      response[:error_code].should == '33'
      response[:error_description].should == 'processing center is having problems'
    end
  end

end