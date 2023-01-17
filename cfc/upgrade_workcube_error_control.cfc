
/*

    File :          cfc\upgrade_workcube_error_control.cfc
    Author :        Uğur Hamurpet<ugurhamurpet@workcube.com>
    Date :          04.09.2019
    Description :   Upgrade sisteminde hata çıktılarını yönetmek için kullanılır.
    
    -----------------------------------------------------------------------------
    
    Methods
        F :  setNewError
            P : errorMessageTitle -         Hata mesajı başlığı atamak için kullanılır
            P : errorMessage -              Hata mesajı atamak için kullanılır.
            P : errorAfterRedirectUrl -     Hata mesajından sonra gidilecek sayfanın linkini atamak için kullanılır
            P : exception -                 Try catch sonrası hata çıktısını struct olarak atamak için kullanılır 

*/

component output="false" displayname="upgradeErrorControl"  {

    this.errorStatus = false;
    this.errorMessageTitle = "";
    this.errorMessage = "";
    this.errorAfterRedirectUrl = "";
    this.exception = "";

    public any function setNewError(string errorMessageTitle, string errorMessage, string errorAfterRedirectUrl = "", string exception) {
        
        this.errorStatus = true;
        this.errorMessageTitle = errorMessageTitle;
        this.errorMessage = errorMessage;
        this.errorAfterRedirectUrl = errorAfterRedirectUrl;
        this.exception = exception;

    }
    
}
