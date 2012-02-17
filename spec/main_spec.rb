require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe 'The bikemiapi App' do

  it "should work" do
    get '/'
    last_response.should be_ok
  end
end
