local android = require("android")
local Device = require("device")
local InputContainer = require("ui/widget/container/inputcontainer")
local DictQuickLookup = require("ui/widget/dictquicklookup")
local _ = require("gettext")

local googleTranslate = InputContainer:new {
  name = "Offline Translate (Google Translate must be Installed)",
  is_doc_only = true,
}

local external = require("device/thirdparty"):new{
  dicts = {
      { "Aard2", "Aard2", false, "itkach.aard2", "aard2" },
      { "Alpus", "Alpus", false, "com.ngcomputing.fora.android", "search" },
      { "ColorDict", "ColorDict", false, "com.socialnmobile.colordict", "send" },
      { "Eudic", "Eudic", false, "com.eusoft.eudic", "send" },
      { "EudicPlay", "Eudic (Google Play)", false, "com.qianyan.eudic", "send" },
      { "Fora", "Fora Dict", false, "com.ngc.fora", "search" },
      { "ForaPro", "Fora Dict Pro", false, "com.ngc.fora.android", "search" },
      { "GoldenFree", "GoldenDict Free", false, "mobi.goldendict.android.free", "send" },
      { "GoldenPro", "GoldenDict Pro", false, "mobi.goldendict.android", "send" },
      { "Kiwix", "Kiwix", false, "org.kiwix.kiwixmobile", "text" },
      { "LookUp", "Look Up", false, "gaurav.lookup", "send" },
      { "LookUpPro", "Look Up Pro", false, "gaurav.lookuppro", "send" },
      { "Mdict", "Mdict", false, "cn.mdict", "send" },
      { "QuickDic", "QuickDic", false, "de.reimardoeffinger.quickdic", "quickdic" },
      { "Translate", "Translate", false, "com.google.android.apps.translate", "text" },
  },
  check = function(self, app)
      return android.isPackageEnabled(app)
  end,
}

local function getExternalDictLookupList(self) 
  return external.dicts 
end

local doExternalDictLookup = function (self, text, method, callback)
  external.when_back_callback = callback
  local _, app, action = external:checkMethod("dict", method)
  if action then
      android.dictLookup(text, app, action)
  end
end

function googleTranslate:init()
  self.ui.highlight:addToHighlightDialog("googletranslate_basic", function(this)
    return {
      text = _("Google Translate"),
      enabled = yes,
      callback = function()
        android.dictLookup(this.selected_text.text, "com.google.android.apps.translate", "text")
        this:onClose()
      end,
    }
  end)
  
  Device.getExternalDictLookupList = getExternalDictLookupList
  Device.doExternalDictLookup = doExternalDictLookup
end

function googleTranslate:onDictButtonsReady(dict_popup, buttons)
  table.insert(buttons, {
      {
          id = "translate",
          text = "Google Translate",
          enabled = true,
          callback = function()
              android.dictLookup(dict_popup.word, "com.google.android.apps.translate", "text")
              dict_popup:onClose()
          end,
      }
  })
end

return googleTranslate
