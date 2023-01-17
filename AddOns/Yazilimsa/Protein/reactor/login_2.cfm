<link rel="stylesheet" href="/src/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="/src/assets/css/login.css?v=23072020">
<script src="/src/assets/js/jquery-3.4.1.slim.min.js" ></script>
<script src="/src/assets/js/popper.min.js"></script>
<script src="/src/assets/js/bootstrap.min.js"></script>
<script src="/src/assets/js/vue.js"></script>
<script src="/src/assets/js/axios.min.js"></script>
<section class="login-block">
  <div class="container" id="protein_login">
    <div class="row">
      <div class="col-md-4 login-sec">
        <h2 class="text-center"><strong style="color: #FF9800;">W<sup>3</sup></strong><span style="color: #03A9F4;">Protein</span></h2>
        <form class="login-form" @submit="sendForm">
          <div class="form-group">
            <label for="exampleInputEmail1" class="text-uppercase">Kod</label>
            <input type="text" class="form-control" placeholder="" v-model="models[0].member_code" required>    
          </div>
          <div class="form-group">
            <label for="exampleInputEmail1" class="text-uppercase">Kullanıcı Adı</label>
            <input type="text" class="form-control" placeholder="" v-model="models[0].username" required>    
          </div>
          <div class="form-group">
            <label for="exampleInputPassword1" class="text-uppercase">Parola</label>
            <input type="password" class="form-control" placeholder="" v-model="models[0].member_password" required>
          </div>
          <div class="form-check pl-0">
            <label class="form-check-label">
              <small class="d-block text-danger" v-if="status_message">{{status_message}}</small>
              <small class="d-block float-left">Şifremi Unuttum</small>              
            </label>
            <button type="submit" class="btn btn-login float-right" v-if="process == 0 || process == 200" :disabled="!send_status">Giriş</button>
            <button type="submit" class="btn btn-info float-right"  v-else-if="process == 201" :disabled="!send_status">Oturumu Kurtar</button>
            <button type="submit" class="btn btn-warning float-right"  v-else :disabled="!send_status">Tekrar Dene</button>
          </div>  
        </form>
        <div class="copy-text">Created with <i class="fa fa-heart"></i> by <a href="http://workcube.com"><strong style="color: #FF9800;">W<sup>3</sup></strong><span style="color: #03A9F4;">Protein</span></a></div>
      </div>
      <div class="col-md-8 banner-sec">
        <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
          <ol class="carousel-indicators">
            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
          </ol>
          <div class="carousel-inner" role="listbox">

            <div class="carousel-item active">
              <img class="d-block img-fluid" src="https://networg.workcube.com/documents/product/BEE31AE3-155D-1309-89F874F218D1ACDB.png" alt="First slide">
              <div class="carousel-caption d-none d-md-block">
                <div class="banner-text">
                </div>	
              </div>
            </div>

          </div>
        </div>   
      </div>
    </div>
  </div>
</section>
<script>
  var proteinApp = new Vue({
    el : '#protein_login',
    data : {
      protein : '2020',
      models : [{
        member_code:'',
        username:'',
        member_password:'',
        force_login:0
      }],
      send_status : true,
      status_message : '',
      process : 0,
      error: []
    },
    methods : {
      sendForm : function(e){
        console.log('FN:LOGIN');
        this.send_status = false;
        axios.post( "/cfc/SYSTEM/LOGIN.cfc?method=GET_LOGIN_CONTROL", proteinApp.models[0])
        .then(response => {
                console.log(response.data);
                if(response.data.STATUS == true){
                    proteinApp.process = response.data.PROCESS;
                    switch(response.data.PROCESS) {
                      case 200:
                        // Başarılı
                        proteinApp.status_message = "Oturum Açıldı, Yönlendiriliyor";
                        setTimeout(function(){location.reload();} , 2000);
                        break;
                      case 201:
                        // Askıda, Kullanıcı Şuan İçeride
                        proteinApp.status_message = "Kullanıcı Şuan İçerideride - CODE:201";
                        proteinApp.models[0].force_login = 1;
                        proteinApp.send_status = true;
                        break;
                      case 202:
                        // Kullanıcı Bilgileri Hatalı
                        proteinApp.status_message = "Kullanıcı Bilgileri Hatalı - CODE:202";
                        proteinApp.send_status = true;
                        break;
                      default:
                        // Başarısız istek
                        proteinApp.status_message = "Başarısız istek";
                        proteinApp.send_status = true;
                    }                    
                }else{
                  switch(response.data.PROCESS) {
                      case 203:
                        // Yanıt alınamadı
                        proteinApp.status_message = "Yanıt alınamadı - CODE:203";
                        proteinApp.send_status = true;
                        break;
                      default:
                        // Başarısız istek
                        proteinApp.status_message = "Başarısız istek";
                        proteinApp.send_status = true;
                    }                  
                }
                                       
        })
        .catch(e => {
            proteinApp.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
            this.send_status = true;
        })   
        e.preventDefault(); return false;
       
      }
    }
  })
</script>