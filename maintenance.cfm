<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Workcube Maintenance Mode</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&display=swap" rel="stylesheet">
    <style>
      body {
        width: 100%;
        height: 100%;
        background-color: #EEF1F5; }

      .logo {
        position: absolute;
        left: 0;
        top: -2px;
        width: 77px;
        height: 60px;
        background: url("/images/workcube_logo.png") no-repeat center top; }

      .box {
        position: absolute;
        width: 100%;
        top: 50%;
        -webkit-transform: translateY(-50%);
        -ms-transform: translateY(-50%);
        transform: translateY(-50%); }
        .box .box_table {
          display: table;
          width: 100%; }
          .box .box_table .box_image {
            display: table-cell;
            height: 500px;
            vertical-align: middle; }
          .box .box_table .box_text {
            display: table-cell;
            height: 500px;
            vertical-align: middle; }
            .box .box_table .box_text h1 {
              font-family: 'Roboto', sans-serif;
              font-size: 55px;
              font-weight: 700;
              color: #FF9800;
              margin: 0 0 20px 0; }
            .box .box_table .box_text p {
              font-family: 'Roboto', sans-serif;
              font-size: 16px;
              margin: 0;
              color: #34495e;
              width: 70%; }

      @media only screen and (max-width: 768px) {
        .col-md-6 {
          padding: 0; }
        .box_image {
          height: 175px !important; }
        .box_text {
          height: 175px !important;
          text-align: center; }
          .box_text h1 {
            font-size: 30px !important; }
          .box_text p {
            width: 100% !important; } }

      @media only screen and (orientation: landscape) and (max-width: 768px) {
        .box .box_image {
          display: none !important; }
        .box .box_text {
          height: 100%; }
          .box .box_text h1 {
            font-size: 40px !important; }
          .box .box_text p {
            width: 80% !important;
            margin: 0 auto !important;
            font-size: 18px !important; } }

    </style>
</head>
<body>
    <div class="logo"></div>
    <div class="box">
        <div class="container">
            <div class="col-md-6 col-sm-6 col-xs-12">
                <div class="box_table">
                    <div class="box_image">
                        <img class="img-responsive" src="images/maintenance.png" alt="Maintance">
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-12">
                <div class="box_table">
                    <div class="box_text">
                        <h1>The system is in maintenance mode.</h1>
                        <p>Please contact with your system administrator!</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>