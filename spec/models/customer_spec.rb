require 'spec_helper'

describe Customer do
  context :greenlight do
    context :facebook_greenlit do
      it 'shoule be true with authorized facebook account' do
        c = Factory :facebook_customer
        c.facebook_greenlit?.should be_false
      end

      it 'should be false with unauthorized facebook account' do
        c = Factory :greenlit_facebook_customer
        c.facebook_greenlit?.should be_true
      end
    end
    context :twitter_greenlit do
      it 'shoule be true with authorized twitter account' do
        c = Factory :twitter_customer
        c.twitter_greenlit?.should be_false
      end

      it 'should be false with unauthorized twitter account' do
        c = Factory :greenlit_twitter_customer
        c.twitter_greenlit?.should be_true
      end
    end
  end

  context :validations do
    it 'should not be valid with nil UUID' do
      c = Factory :customer
      c.uuid = nil
      c.valid?.should be_false
    end

    it 'should allow long UUIDs' do
      c = Factory :customer
      string = rand_string(100)
      c.uuid = string
      c.valid?.should be_true
      c.save
      c.reload
      c.uuid.should eq string
    end

    def rand_string(range = 25)
      alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
      (0...25).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
    end
  end
end
