module Koala
  module Facebook
    class API

      def get_object(parametro)
        if access_token == "1234567890_VALID"  
          {"first_name"=>"Test", "last_name"=>"test", "email"=>"test2@api_base.com", "id"=>"1234567890"}
        elsif access_token == "1111111111_VALID"  
          {"first_name"=>"Test2", "last_name"=>"test2", "email"=>"test3@api_base.com", "id"=>"1111111111"}
        else
          ex = Koala::Facebook::AuthenticationError.new 400, 'error'
          raise ex
        end
      end
    end
  end
end
