
/*
    File :          cfc\upgrade.cfc
    Author :        Uğur Hamurpet<ugurhamurpet@workcube.com>
    Date :          03.09.2019
    Description :   Upgrade sisteminde sürüm geçişleri sırasında kullanılır.
                    Sürüm geçişi sırasında gerekli bilgileri application seviyesinde tutmak ve sayfalar arasında taşımak için kullanılır.
                    Sistem bakım moduna geçtiğinde status değerini true yaparak sisteme girişleri application on request te engeller.
*/

component output="false" displayname="upgrade"  {

    this.status = false;
    this.step = "";
    this.release_no = "";
    this.last_release_date = "";
    this.release_date = "";
    this.patch_no = "";
    this.patch_date = "";

    public function set( boolean status, string step, string release_no, string last_release_date, string release_date, string patch_no = '', string patch_date = '' ) {

        this.status = status;
        this.step = step;
        this.release_no = release_no;
        this.last_release_date = last_release_date;
        this.release_date = release_date;
        this.patch_no = patch_no;
        this.patch_date = patch_date;

    }

}