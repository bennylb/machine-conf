require 'mp.set_property'
require 'mp.utils'

function set_ao ()
   local proc = {"/usr/bin/pidof", "pulseaudio"}
   local proc_rt = utils.subprocess({t.args=proc})
   local rt_val = proc_rt.stdout
   if rt_val != nil then
      -- current-ao set here
      mp.set_property("current-ao", "pulse")
   else
      mp.set_property("current-ao", "alsa:device=[hw:0,0]")
   end
end

set_ao()
