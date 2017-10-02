#https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=New+York+City,NY&destinations=New+York+City,NY&key=AIzaSyAikI3ytmCX_h5N5lmVVVMQ5eoCSinfQOA
require 'pry'


response = {
   "destination_addresses" : [ "Indianapolis, IN, USA" ],
   "origin_addresses" : [ "New York, NY, USA" ],
   "rows" : [
      {
         "elements" : [
            {
               "distance" : {
                  "text" : "708 mi",
                  "value" : 1139276
               },
               "duration" : {
                  "text" : "11 hours 2 mins",
                  "value" : 39723
               },
               "status" : "OK"
            }
         ]
      }
   ],
   "status" : "OK"
}

binding.pry
