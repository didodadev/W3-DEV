<html>
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <cfoutput> 
        <cfset PRIMARY_DATA = #deserializeJSON(GET_SITE.PRIMARY_DATA)#>
        <meta name="description" content="#PRIMARY_DATA.DETAIL#" >
        <meta name="keywords" content="#PRIMARY_DATA.META_KEYWORD#" >
        <title>#PRIMARY_DATA.TITLE#</title>
    </cfoutput>
    <style>
      body{
      background:#ddd;
      }
      .form-signin
      {
          max-width: 330px;
          padding: 15px;
          margin: 0 auto;
          padding-top: 5px;
      }
      .form-signin .form-signin-heading, .form-signin .checkbox
      {
          margin-bottom: 10px;
      }
      .form-signin .checkbox
      {
          font-weight: normal;
      }
      .form-signin .form-control
      {
          position: relative;
          font-size: 16px;
          height: auto;
          padding: 10px;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
      }
      .form-signin .form-control:focus
      {
          z-index: 2;
      }
      .form-signin input[type="password"]
      {
          margin-bottom: 10px;
      }
      .account-wall
      {
          margin-top: 20px;
          padding: 40px 0px 20px 0px;
          background-color: #f7f7f7;
          -moz-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
          -webkit-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
          box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
      }
      .login-title
      {
          color: #555;
          font-size: 18px;
          font-weight: 400;
          display: block;
      }
      .profile-img
      {
          height: 50px;
          margin: 0 auto 10px;
          display: block;     
      }
      .profile-name {
          font-size: 16px;
          font-weight: bold;
          text-align: center;
          margin: 10px 0 0;
          height: 1em;
      }
      .profile-email {
          display: block;
          padding: 0 8px;
          font-size: 15px;
          color: #404040;
          line-height: 2;
          font-size: 14px;
          text-align: center;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          -moz-box-sizing: border-box;
          -webkit-box-sizing: border-box;
          box-sizing: border-box;
      }
      .need-help
      {
          display: block;
          margin-top: 10px;
      }
      .new-account
      {
          display: block;
          margin-top: 10px;
      }
    </style>
    <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
    <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
  </head>
<body> 
  <div id="protein_admin" class="container">
    <div class="container">
        <div class="row justify-content-center mt-5">
          <div class="col-sm-6 col-md-4 col-md-offset-4">
            <h1 class="text-center login-title">Protein Admin Login</h1>
            <div class="account-wall">
              <img class="profile-img" src="/src/assets/img/protein_logo.png"alt="">
              <p class="profile-name"></p>
              <span class="profile-email">admin mode parolasını giriniz.</span>
              <form class="form-signin"  @submit="sendForm">
                <input type="password" class="form-control" placeholder="Password" required autofocus v-model="models[0].admin_password">
                <button class="btn btn-lg btn-primary btn-block" type="submit">
                Sign in</button>
                <div class="need-help" v-if="status_message">{{status_message}} </dib><span class="clearfix"></span>
              </form>
            </div>
            <a href="www.workcube.com" class="text-center new-account">www.workcube.com</a>
          </div>
        </div>
    </div>
  </div>
  <script>
    var proteinApp = new Vue({
      el : '#protein_admin',
      data : {
        protein : '2020',
        models : [{
            admin_password:''         
        }],           
        status_message : '',           
        error: [],
      },
      methods : {
        sendForm : function(e){
        e.preventDefault(); 
          proteinApp.status_message = 'Gönderiliyor...',
          axios.post( "/cfc/SYSTEM/LOGIN.cfc?method=admin_view", proteinApp.models[0])
          .then(response => {
                console.log(response.data);
                if(response.data.STATUS == true){
                    proteinApp.process = response.data.PROCESS;
                    switch(response.data.PROCESS) {
                    case 200:
                        // Başarılı
                        proteinApp.status_message = "Yönlendiriliyor";
                        setTimeout(function(){window.location.assign("/");} , 2000);
                        break;
                    case 202:
                        // Kullanıcı Bilgileri Hatalı
                        proteinApp.status_message = "Yanlış Parola";
                        break;
                    default:
                        // Başarısız istek
                        proteinApp.status_message = "Başarısız istek";
                    }                    
                }else{
                switch(response.data.PROCESS) {
                    case 203:
                        // Yanıt alınamadı
                        proteinApp.status_message = "Yanıt alınamadı - CODE:203";
                        break;
                    default:
                        // Başarısız istek
                        proteinApp.status_message = "Başarısız istek";
                        proteinApp.send_status = true;
                    }                  
                }                                            
          })
          .catch(e => {
                proteinApp.status_message = 'Şuanda İşlem Yapılamıyor....',
                proteinApp.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
          })
          e.preventDefault(); return false;
        }
      }
    })
  </script>
</body>
</html>