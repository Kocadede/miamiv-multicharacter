
var id = 1;
var pageid=1;

function play() {
    $.post("http://miamiv-multichar/CharacterChosen", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
        ischar: $('.active-char').attr("data-ischar"),
        loc : $('#location option:selected').val(),
    }));

    Kashacter.CloseUI();
}

$("#deletechar").click(function () {
    $.post("http://miamiv-multichar/DeleteCharacter", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
    }));
    Kashacter.CloseUI();
});

function onceki() {
    if (pageid != 1) {
        $('[data-charid=' + pageid + ']').css({"display": "none"})
        $('[data-charid=' + pageid + ']').removeClass('active-char')
        pageid--;
        $('[data-charid=' + pageid + ']').css({"display": "block"})
        $('[data-charid=' + pageid + ']').addClass('active-char')
   
        $.post("http://miamiv-multichar/changeCharacter", JSON.stringify({
            charId : pageid
        }));
   
    }
}

function sonraki(){
    if (pageid != 4) {


        $('[data-charid=' + pageid + ']').css({"display": "none"})
        $('[data-charid=' + pageid + ']').removeClass('active-char')
        pageid++;

        $('[data-charid=' + pageid + ']').css({"display": "block"})
        $('[data-charid=' + pageid + ']').addClass('active-char')
        $.post("http://miamiv-multichar/changeCharacter", JSON.stringify({
            charId : pageid
        }));




    }
}




(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
        $('.main-container').css({"display":"block"});
        $('[data-charid=1]').addClass('active-char')

        
        if(data.characters !== null) {
            $.each(data.characters, function (index, char) {
                    if (char.sex == "M" ) {
                        char.sex = "Erkek"
                    } else {
                        char.sex = "Kadın"
                    }

                    var img 
                    if (char.avatar != null) {
                        img = char.avatar.avatar_url
                    } else {
                        img = "https://media.discordapp.net/attachments/819204223266455563/819620673927774259/116.png"
                    }



                    var header = '<div class="row"> <div class="player"> <ul flex-direction="row"> <li> <img src=' + img +' style="width: 116px; height: 116px;"> </li> <li> <p class="x"  >' + char.firstname + ' ' + char.lastname + '</p> <p class="y yellow-text" id="job">'+ char.job+'</p> </li> </ul> </div> </div>'
                    var left = '<div class="center mr-20" style="left: 35%  !important;"> <li> <div class="lh-8">  <p class="yellow-text">Cinsiyet</p>  <p>' + char.sex + '</p>  </div> </li>     <li> <div class="lh-8">  <p class="yellow-text">Nakit</p>  <p>' + char.money + '</p>  </div> </li>   <li> <div class="lh-8">  <p class="yellow-text">Telefon Numarası</p>  <p>' + char.phone_number + '</p>  </div> </li>     </div>'
                    var right = '<div class="center mr-20" style="left: 70% !important;"> <li> <div class="lh-8">  <p class="yellow-text">Doğum Tarihi</p>  <p>' + char.dateofbirth + '</p>  </div> </li>           <li> <div class="lh-8">  <p class="yellow-text">Banka</p>  <p>' + char.bank + '</p>  </div> </li>    <li> <div class="lh-8">  <p class="yellow-text">Boy</p>  <p>  ' + char.height +' </p>  </div> </li>   </div>'
                    var desc = '<div class="row"><div class="description"><ul><li> <i class="fas fa-chevron-left center left size-30 slidebutton" id="onceki" onclick="onceki()"></i> </li>       '+  left +  right + '         <li> <i class="fas fa-chevron-right center right size-30 slidebutton" id="sonraki" onclick="sonraki()"></i></li>            </ul></div></div>'

                    var button = '<div class="row bottom-0" > <input class="play-button yellow-text left-min" type="button" value="Seç" onclick="play()">     </div>'
                    
                    $('[data-charid=' + id + ']').html('<div class="container">'+ header + desc + button + '</div>').attr("data-ischar", "true");
                    id++
                    
                
            });            
        }
    };

               

    Kashacter.CloseUI = function() {
        $('.body').css({"display":"none"});
    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case 'openui':
                    Kashacter.ShowUI(event.data);
                    break;
                }
            })
        }
    })
();

