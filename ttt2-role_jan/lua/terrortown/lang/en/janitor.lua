local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[JANITOR.name] = "Janitor"
L["info_popup_" .. JANITOR.name] = [[You are the Janitor! Clean up bodies or DNA with your broom!]]
L["body_found_" .. JANITOR.abbr] = "They were a Janitor."
L["search_role_" .. JANITOR.abbr] = "This person was a Janitor!"
L["target_" .. JANITOR.name] = "Janitor"
L["ttt2_desc_" .. JANITOR.name] = [[The Janitor needs to use his broom to clean up bodies and DNA.]]
L["credit_" .. JANITOR.abbr .. "_all"] = "Janitor, you have been awarded {num} equipment credit(s) for your performance."

-- EXTRA ROLE STRINGS
L["label_jan_mop_cooldown"] = "How long until the janitor can mop again: "
L["label_jan_help_m1"] = "Clean up a body (on a cooldown)."
L["label_jan_help_m2"] = "Clean up DNA on a body."
L["jan_broom_title"] = "Janitor Broom"
L["jan_broom_desc"] = "Clean up bodies and DNA!"
L["jan_sweepCD_title"] = "Sweep Cooldown"
L["jan_sweepCD_desc"] = "You have swept a body recently, you must wait to do it again."