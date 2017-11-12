;====================== Path of file Config.ini =====================================
Global $configPath = @ScriptDir&"\config Xml2MySql.ini"

;Default
;Global $WorkingDir = IniRead($configPath,"app","WorkingDir ", "")
Global $WorkingDir = @DesktopDir

;========GUI config ==============

Global $TitleGui = IniRead($configPath,"gui","titleGui","Tool 1.2")
Global $WidthGui =  IniRead($configPath,"gui","widthGui","200")
Global $HeightGui =  IniRead($configPath,"gui","heightGui","120")
Global $ErrorDiaglogTitle = IniRead($configPath,"gui","errorDiaglogTitle","Error")
Global $fontSizeComboBox = 9

; Max length cho Input cua GUI
Global $maxLengthTextField = IniRead($configPath,"gui","maxLengthTextField","100")

;====== App ======================

Global $MaxLengthVarchar = IniRead($configPath,"app","MaxLengthVarchar","150")
Global $MaxLengthVarcharPhone =  IniRead($configPath,"app","MaxLengthVarcharPhone","30")

Global $PathEclipse = IniRead($configPath,"app","PathEclipse", "")
Global $suffix = IniRead($configPath,"app","suffix", "Tab")

;====== Mode Write =============================================
Global $utf8 = IniRead($configPath,"fixMode","utf8","32")

;event ComboBox
Global $ComboBox_Changed = False
Global $DebugIt = 1
Global $changed = 0

;color
Global $yellow = 0xFFFC22
Global $darkRed = 0x8B0000
Global $red = 0xFF0000
Global $successColor = 0xF11C22
Global $MediumVioletRed = 0xC71585
Global $teal= 0x00FFFF
Global $white = 0xFFFFFF
Global $xanhLaChuoi = 0x55FFAA
Global $index0Combo = "--------------"

;====================== inputText =================================================
Global $maxLengthInput = IniRead($configPath,"inputText","maxlengthInput","200")
Global $maxlengthTextArea = IniRead($configPath,"inputText","maxlengthTextArea","600")

;====================== Mode Write to file =====================================
Global $modeWrite = 10+$utf8

;====================== Sub List Table =====================================
Global $listVaribleInJsp = ''
Global $tableListInJsp = ''
Global $includeListJspInJsp = ''
Global $sessionForList = ''

;=============== JSP ===========================================================
Global $jspFolderTemplate = IniRead($configPath,"jsp","jspFolderTemplate","\formHTML\BN\")
Global $jspRegistry = IniRead($configPath,"jsp","jspRegistry ","jsp_registry.txt")
Global $jspReview = IniRead($configPath,"jsp","jspReview ","jsp_review.txt")
Global $saveActionPortlet = IniRead($configPath,"jsp","saveActionPortlet ","saveActionPortlet")
Global $utilsJava = IniRead($configPath,"jsp","utilsJava ","utilsJava")
Global $validatorJava = IniRead($configPath,"jsp","validatorJava ","validatorJava")
Global $config = IniRead($configPath,"jsp","config ","config")
Global $businessUtils = IniRead($configPath,"jsp","businessUtils ","config")

Global $reviewString = IniRead($configPath,"jsp","reviewString ","review_string.jsp")
Global $reviewStringTextArea = IniRead($configPath,"jsp","reviewStringTextArea ","review_string_textarea.jsp")

Global $registryStringTextArea = IniRead($configPath,"jsp","registryStringTextArea ","registry_string_textarea.jsp")
Global $registryStringLgTextArea = IniRead($configPath,"jsp","registryStringLgTextArea ","registry_string_lgTextarea.jsp")
Global $registryStringInput = IniRead($configPath,"jsp","registryStringInput ","registry_string_input.jsp")
Global $registryStringCmnd = IniRead($configPath,"jsp","registryStringCmnd ","registry_string_cmnd.jsp")
Global $registryStringPhone = IniRead($configPath,"jsp","registryStringPhone ","registry_string_phone.jsp")
Global $registryStringEmail = IniRead($configPath,"jsp","registryStringEmail ","registry_string_email.jsp")
Global $registryStringWebsite = IniRead($configPath,"jsp","registryStringWebsite ","registry_string_website.jsp")
Global $registryStringNumFormat = IniRead($configPath,"jsp","registryStringNumFormat ","registry_string_numFormat.jsp")
Global $registryStringFloatFormat = IniRead($configPath,"jsp","registryStringFloatFormat ","registry_string_floatFormat.jsp")
Global $registryStringNumeric = IniRead($configPath,"jsp","registryStringNumeric ","registry_string_numeric.jsp")
Global $registryStringUpper = IniRead($configPath,"jsp","registryStringUpper ","registry_string_upper.jsp")

Global $validateStringTextArea = IniRead($configPath,"jsp","validateStringTextArea ","validate_string_textarea.java")
Global $validateStringLgTextArea = IniRead($configPath,"jsp","validateStringLgTextArea ","validate_string_lgTextarea.java")
Global $validateStringInput = IniRead($configPath,"jsp","validateStringInput ","validate_string_input.java")
Global $validateStringCmnd = IniRead($configPath,"jsp","validateStringCmnd ","validate_string_cmnd.java")
Global $validateStringPhone = IniRead($configPath,"jsp","validateStringPhone ","validate_string_phone.java")
Global $validateStringWebsite= IniRead($configPath,"jsp","validateStringWebsite ","validate_string_website.java")
Global $validateStringNumFormat = IniRead($configPath,"jsp","validateStringNumFormat ","validate_string_numFormat.java")
Global $validateStringFloatFormat = IniRead($configPath,"jsp","validateStringFloatFormat ","validate_string_floatFormat.java")
Global $validateStringNumeric = IniRead($configPath,"jsp","validateStringNumeric ","validate_string_numeric.java")
Global $validateStringEmail = IniRead($configPath,"jsp","validateStringEmail ","validate_string_email.java")

Global $reviewDate = IniRead($configPath,"jsp","reviewDate ","review_date.jsp")
Global $registryDateInput = IniRead($configPath,"jsp","registryDateInput ","registry_date_input.jsp")

Global $registryLongCmnd = IniRead($configPath,"jsp","registryLongCmnd ","registry_long_cmnd.txt")
Global $registryLongHoChieu= IniRead($configPath,"jsp","registryLongHoChieu ","registry_long_hochieu.txt")
Global $registryLongNation = IniRead($configPath,"jsp","registryLongNation ","registry_long_nation.jsp")
Global $registryLongSex = IniRead($configPath,"jsp","registryLongSex ","registry_long_sex.jsp")
Global $registryLongDantoc = IniRead($configPath,"jsp","registryLongDantoc ","registry_long_dantoc.jsp")
Global $registryLongCity = IniRead($configPath,"jsp","registryLongCity ","registry_long_city.jsp")
Global $registryLongQuanhe = IniRead($configPath,"jsp","registryLongQuanhe ","registry_long_quanhe.jsp")
Global $registryLongJob = IniRead($configPath,"jsp","registryLongJob ","registry_long_job.jsp")
Global $registryLongAdress = IniRead($configPath,"jsp","registryLongAdress ","registry_long_adress.jsp")
Global $registryLongGiayToCmnd = IniRead($configPath,"jsp","registryLongGiayToCmnd ","registry_long_giayto_cmnd.jsp")
Global $registryLongOther = IniRead($configPath,"jsp","registryLongOther ","registry_long_other.jsp")

Global $reviewLong = IniRead($configPath,"jsp","reviewLong","review_long.jsp")
Global $reviewLongCmnd = IniRead($configPath,"jsp","reviewLongCmnd","review_long_cmnd.jsp")
Global $reviewLongNation = IniRead($configPath,"jsp","reviewLongNation","review_long_nation.jsp")
Global $reviewLongDantoc = IniRead($configPath,"jsp","reviewLongDantoc","review_long_dantoc.jsp")
Global $reviewLongSex = IniRead($configPath,"jsp","reviewLongSex","review_long_sex.jsp")
Global $reviewLongQuanHe = IniRead($configPath,"jsp","reviewLongQuanHe ","review_long_quanhe.jsp")
Global $reviewLongCity = IniRead($configPath,"jsp","reviewLongCity","review_long_city.jsp")
Global $reviewLongJob = IniRead($configPath,"jsp","reviewLongJob","review_long_job.jsp")
Global $reviewLongAddress = IniRead($configPath,"jsp","reviewLongAddress","review_long_address.jsp")
Global $reviewLongGiayToCmnd = IniRead($configPath,"jsp","reviewLongGiayToCmnd","review_long_giayto_cmnd.jsp")

Global $validateLong0 = IniRead($configPath,"jsp","validateLong0","validate_long_0.java")
Global $validateLongLess0 = IniRead($configPath,"jsp","validateLongLess0","validate_long_less0.java")
Global $validateLongAddress = IniRead($configPath,"jsp","validateLongAddress","validate_long_address.java")
Global $validateLongGiayToCmnd= IniRead($configPath,"jsp","validateLongGiayToCmnd","validate_long_giayto_cmnd.java")