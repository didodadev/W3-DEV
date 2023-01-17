<link rel="stylesheet" href="/src/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="/src/assets/css/login_3.css">
<script src="/src/assets/js/jquery-3.4.1.slim.min.js" ></script>
<script src="/src/assets/js/popper.min.js"></script>
<script src="/src/assets/js/bootstrap.min.js"></script>
<script src="/src/assets/js/vue.js"></script>
<script src="/src/assets/js/axios.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">     

<div id="protein-login" class="container">
    <div class="row justify-content-center">
        <div class="col-xl-10">
            <div class="card border-0">
                <div class="card-body p-0">
                    <div class="row no-gutters">
                        <div class="col-lg-6">
                            <div class="p-5">
                                <div class="mb-5">
                                    <h3 class="h4 font-weight-bold text-theme">Login</h3>
                                </div>

                                <h6 class="h5 mb-0">Hoşgeldiniz!</h6>
                                <p class="text-muted mt-2 mb-5">Lütfen Bilgilerinizi Giriniz.</p>

                                <form @submit="sendForm" class="login-form">
                                    <div class="form-group">
                                        <label for="exampleInputEmail1">Kurumsal Üye Kodu</label>
                                        <input type="text" class="form-control" id="exampleInputEmail1" v-model="models[0].member_code" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="exampleInputEmail1">Kullanıcı E-Mail</label>
                                        <input type="text" class="form-control" id="exampleInputEmail1" v-model="models[0].username" required>
                                    </div>
                                    <div class="form-group mb-5">
                                        <label for="exampleInputPassword1">Password</label>
                                        <input type="password" class="form-control" id="exampleInputPassword1" v-model="models[0].member_password" required>
                                    </div>
                                    <div class="form-check pl-0">
                                        <label class="form-check-label">
                                          <small class="d-block text-danger" v-if="status_message">{{status_message}}</small>
                                          <small class="d-block float-left">Şifremi Unuttum</small>              
                                        </label>
                                        <button type="submit" class="btn btn-theme float-right" v-if="process == 0 || process == 200" :disabled="!send_status">Giriş</button>
                                        <button type="submit" class="btn btn-info float-right"  v-else-if="process == 201" :disabled="!send_status">Oturumu Kurtar</button>
                                        <button type="submit" class="btn btn-warning float-right"  v-else :disabled="!send_status">Tekrar Dene</button>
                                      </div> 
                                    
                               
                                </form>
                            </div>
                        </div>

                        <!-- <div class="col-lg-6 d-none d-lg-inline-block">
                            <div class="account-block rounded-right">
                                <div class="overlay rounded-right"></div>
                                <div class="account-testimonial">
                                    <h4 class="text-white mb-4">This  beautiful theme yours!</h4>
                                    <p class="lead text-white">"Best investment i made for a long time. Can only recommend it for other users."</p>
                                    <p>- Admin User</p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>  -->
                <!-- end card-body -->
            </div>
            <!-- end card -->

           
            <!-- end row -->

        </div>
        <!-- end col -->
    </div>
    <!-- Row -->
</div>

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