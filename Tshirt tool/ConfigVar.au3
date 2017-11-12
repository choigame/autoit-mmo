
Global $configPath = @ScriptDir&"\config.ini"
Global $collectionPath = IniRead($configPath,"sunfrog","collectionINI","")

;========GUI config ==============

Global $APPTITLE = IniRead($configPath,"gui","APPTITLE","Tool 1.2")
Global $XGUI = IniRead($configPath,"gui","XGUI","400")
Global $YGUI = IniRead($configPath,"gui","YGUI","250")

Global $ROOTMAIL = IniRead($configPath,"gui","ROOTMAIL","")
Global $ROOTIMG = IniRead($configPath,"gui","ROOTIMG","")

Global $RegexTagsTeespring  = IniRead($configPath,"regex","RegexTagsTeespring","")
Global $RegexEmail = IniRead($configPath,"regex","RegexEmail","")

GLobal $ImgScreenX1 =   IniRead($configPath,"ImgScreen","ImgScreenX1","")
GLobal $ImgScreenY1 =   IniRead($configPath,"ImgScreen","ImgScreenY1","")
GLobal $ImgScreenX2 =   IniRead($configPath,"ImgScreen","ImgScreenX2","")
GLobal $ImgScreenY2 =   IniRead($configPath,"ImgScreen","ImgScreenY2","")


;------- tshirt -------
Global $tshirtColors = IniRead($configPath,"sunfrog","tshirtColors","")
Global $colors = StrToArray($tshirtColors)

Global $categories = IniRead($configPath,"sunfrog","categories","")
Global $collections = IniRead($collectionPath,"collection","collections","")
Global $descWordLength = IniRead($collectionPath,"sunfrog","descWordLength","")


#comments-start
Global $sunfrogCategories    = 'sunfrogCategories.txt'
Global $sunfrogColorApparel   = 'sunfrogColorApparel.txt'
Global $sunfrogTypeApparel    = 'sunfrogTypeApparel.txt'
#comments-end

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

