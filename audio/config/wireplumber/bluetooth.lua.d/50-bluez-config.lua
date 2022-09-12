rule = {
  matches = {
    {
      { "node.name", "equals", "bluez_card.*" },
    },
  },
  apply_properties = {
		["bluez5.codecs"] = "[ aptx aac ]",
		["bluez5.auto-connect"] = "[ hfp_hf hfp_ag hsp_hs hsp_ag a2dp_sink a2pd_source ]"
  },
}

table.insert(bluez_monitor.rules,rule)
