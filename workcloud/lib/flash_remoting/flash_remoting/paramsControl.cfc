
    /**
    *
    * @file  paramsControl.cfc
    * @author  Uğur Hamurpet
    * @description : Upgrade sisteminde params.cfc yi application dışındaki dosyalardan kurmak sorun yarattığından dsn.txt ismindeki dosyadan okuma yöntemi uygulandı.
    * @date : 31/07/2019
    *
    */
    
    component output="true" displayname="paramsControl"  {
    
        basePath = GetDirectoryFromPath(GetCurrentTemplatePath());

        public string function getdsn() {
            
            if(FileExists(basePath & "/dsn.txt")){
                return fileRead(basePath & "/dsn.txt");
            }else{
                var params = new WMO.params();
                return params.systemParam().dsn;
            }

        }

    }