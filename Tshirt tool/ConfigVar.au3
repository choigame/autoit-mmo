
Global $configPath = @ScriptDir&"\config.ini"
Global $collectionPath = IniRead($configPath,"sunfrog","collectionINI","")

;========GUI config ==============

Global $APPTITLE = IniRead($configPath,"gui","APPTITLE","Tool 1.2")
Global $XGUI = IniRead($configPath,"gui","XGUI","400")
Global $YGUI = IniRead($configPath,"gui","YGUI","250")

;file OUTPUT
Global $ROOTMAIL = IniRead($configPath,"utils","ROOTMAIL","")
Global $ROOTIMG = IniRead($configPath,"utils","ROOTIMG","")
Global $ROOT_MAIL_REMOVE_BOUNCE = IniRead($configPath,"utils","ROOT_MAIL_REMOVE_BOUNCE","")
Global $BounceMailFileExt = IniRead($configPath,"utils","BounceMailFileExt","")

GLobal $PNG_DESIGN_DIR =  IniRead($configPath,"utils","PNG_DESIGN_DIR","")

Global $RegexTagsTeespring  = IniRead($configPath,"regex","RegexTagsTeespring","")
Global $RegexEmail = IniRead($configPath,"regex","RegexEmail","")

GLobal $ImgScreenX1 =   IniRead($configPath,"ImgScreen","ImgScreenX1","")
GLobal $ImgScreenY1 =   IniRead($configPath,"ImgScreen","ImgScreenY1","")
GLobal $ImgScreenX2 =   IniRead($configPath,"ImgScreen","ImgScreenX2","")
GLobal $ImgScreenY2 =   IniRead($configPath,"ImgScreen","ImgScreenY2","")



;------- sunfrog -------
Global $SUNFROG_LOGIN_URL =  IniRead($configPath,"sunfrog","SUNFROG_URL","")
Global $SUNFROG_UPLOAD_URL =  IniRead($configPath,"sunfrog","SUNFROG_UPLOAD_URL","")
Global $SUNFROG_USER_DEFAULT =  IniRead($configPath,"sunfrog","SUNFROG_USER_DEFAULT","")

Global $teeColorsConfig = IniRead($configPath,"sunfrog","teeColors","")
Global $teeColors = StrToArray($teeColorsConfig)

Global $hoodieColorsConfig = IniRead($configPath,"sunfrog","hoodieColors","")
Global $hoodieColors = StrToArray($hoodieColorsConfig)

Global $sweatColorsConfig = IniRead($configPath,"sunfrog","sweatColors","")
Global $sweatColors = StrToArray($sweatColorsConfig)

Global $uniLSleeveColorsConfig = IniRead($configPath,"sunfrog","uniLSleeveColors","")
Global $uniLSleeveColors = StrToArray($uniLSleeveColorsConfig)

Global $categories = IniRead($configPath,"sunfrog","categories","")
Global $collections = IniRead($collectionPath,"collection","collections","")
Global $sunfrogDescWordLength = IniRead($configPath,"sunfrog","sunfrogDescWordLength","")

Global $TITLE_DEFAULT = IniRead($configPath,"sunfrog","TITLE_DEFAULT","")
Global $DESC_DEFAULT = IniRead($configPath,"sunfrog","DESC_DEFAULT","#KEY Apparel. Best Gifts For You.")

Global $SUNFROG_MAX_COLOR_PICK = 3


#comments-start
Global $sunfrogCategories    = 'sunfrogCategories.txt'
Global $sunfrogColorApparel   = 'sunfrogColorApparel.txt'
Global $sunfrogTypeApparel    = 'sunfrogTypeApparel.txt'
#comments-end

Global $sunfrogCategoryDB =  IniRead($configPath,"sunfrog",'sunfrogCategoryDB',"")

Global $sunfrogGuysTeePrice = IniRead($configPath,"sunfrog",'sunfrogGuysTeePrice',"19")
Global $sunfrogLadyTeePrice = IniRead($configPath,"sunfrog",'sunfrogLadyTeePrice',"19")
Global $sunfroghoodiePrice = IniRead($configPath,"sunfrog",'sunfroghoodiePrice',"34")
Global $sunfrogSweatPrice = IniRead($configPath,"sunfrog",'sunfrogSweatPrice',"31")
Global $sunfrogUniLSleevePrice = IniRead($configPath,"sunfrog",'sunfrogUniLSleevePrice',"31")
Global $sunfrogColoredMugPrice = IniRead($configPath,"sunfrog",'sunfrogColoredMugPrice',"8.99")

Global $sunfrogDataUploadJSONTemp =  IniRead($configPath,"sunfrog",'sunfrogDataUploadJSONTemp',"")
Global $sunfrogTypeJSONTemp  = IniRead($configPath,"sunfrog",'sunfrogTypeJSONTemp',"")
Global $sunfrogImagesJSONTemp  = IniRead($configPath,"sunfrog",'sunfrogImagesJSONTemp',"")

Global $sunfrogImageFrontJSONTemp = IniRead($configPath,"sunfrog",'sunfrogImageFrontJSONTemp',"")
Global $sunfrogImageBackJSONTemp = IniRead($configPath,"sunfrog",'sunfrogImageBackJSONTemp',"")

