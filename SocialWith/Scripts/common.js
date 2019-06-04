
function autoHypenPhone(str) {
    str = str.replace(/[^0-9]/g, '');
    var tmp = '';
    if (str.length < 4) {
        return str;
    } else if (str.length < 7) {
        tmp += str.substr(0, 3);
        tmp += '-';
        tmp += str.substr(3);
        return tmp;
    } else if (str.length < 11) {
        tmp += str.substr(0, 3);
        tmp += '-';
        tmp += str.substr(3, 3);
        tmp += '-';
        tmp += str.substr(6);
        return tmp;
    } else {
        tmp += str.substr(0, 3);
        tmp += '-';
        tmp += str.substr(3, 4);
        tmp += '-';
        tmp += str.substr(7);
        return tmp;
    }
    return str;
}

// Except only numbers and dot (.) for salary textbox
function onlyDotsAndNumbers(event) {
    var charCode = (event.which) ? event.which : event.keyCode
    if (charCode == 46) {
        return true;
    }
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;

    return true;
}
//Except only numbers for Age textbox
function onlyNumbers(event) {
    event = event || window.event;
    var charCode = (event.which) ? event.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
    {
        return false;

    }

    if (event.keyCode == 13) {
        event.preventDefault();
        return false;
    }
    return true;
}

//엔터방지
function preventEnter(event) {
    if (event.keyCode == 13) {
        event.preventDefault();
        return false;
    }
}
// No alphabets for Emp No textbox
function noAlphabets(event) {
    var charCode = (event.which) ? event.which : event.keyCode
    if ((charCode >= 97) && (charCode <= 122) || (charCode >= 65) && (charCode <= 90))
        return false;

    return true;
}


//jquery ajax function화(중복호출제거)
var JajaxDuplicationCheck = function (type, url, data, datatype, _callback, _beforeSend, _complete, issessionCheck , sessionValue) {

    if (issessionCheck) {
        if (sessionValue == "" || sessionValue == null) {
            alert("로그인 연결이 끊겼습니다. 다시 로그인 해 주세요.");
            location.href = '../../Member/Login.aspx';
            return false;
        }
    }
    

    $.ajax({
        type: type,
        url: url,
        cache: false,
        data: data,
        dataType: datatype,
        beforeSend: _beforeSend,
        complete: _complete,
        success: _callback,
        error: function (xhr, status, error) {
            if (xhr.readyState == 0 || xhr.status == 0) {
                return; //Skip this error
            }
            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        }
    });
}

//jquery ajax function화
var Jajax = function (type, url, data, datatype, callback) {
    $.ajax({
        type: type,
        url: url,
        cache: false,
        data: data,
        dataType: datatype,
        success: callback,
        error: function (xhr, status, error) {
            if (xhr.readyState == 0 || xhr.status == 0) {
                return; //Skip this error
            }
            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        }
    });
}

//jquery ajax function화
var JqueryAjax = function (type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue) {

    if (issessionCheck) {
        if (sessionValue == "" || sessionValue == null) {
            alert("로그인 연결이 끊겼습니다. 다시 로그인 해 주세요.");
            location.href = '../../Member/Login.aspx';
            return false;
        }
    }

    $.ajax({
        type: type,
        url: url,
        async: async,
        cache: cache,
        data: data,
        dataType: datatype,
        beforeSend: _beforeSend,
        complete: _complete,
        success: _callback,
        error: function (xhr, status, error) {
            if (xhr.readyState == 0 || xhr.status == 0) {
                return; //Skip this error
            }
            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        }
    });
}

//jquery ajax function화 세션 체크
var JajaxSessionCheck = function (type, url, data, datatype, callback, sessionValue) {

    if (sessionValue == "" || sessionValue == null) {
        alert("로그인 연결이 끊겼습니다. 다시 로그인 해 주세요.");
        location.href = '../../Member/Login.aspx';
        return false;
    }

    $.ajax({
        type: type,
        url: url,
        cache: false,
        data: data,
        dataType: datatype,
        success: callback,
        error: function (xhr, status, error) {
            if (xhr.readyState == 0 || xhr.status == 0) {
                return; //Skip this error
            }
            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        }
    });
}

//jquery ajax function화 세션 체크 + complete 시 호출 함수 기능 추가
var JajaxSessionCheckCompl = function (type, url, data, datatype, callback, complFunc, sessionValue) {

    if (sessionValue == "" || sessionValue == null) {
        alert("로그인 연결이 끊겼습니다. 다시 로그인 해 주세요.");
        location.href = '../../Member/Login.aspx';
        return false;
    }

    $.ajax({
        type: type,
        url: url,
        cache: false,
        data: data,
        dataType: datatype,
        success: callback,
        error: function (xhr, status, error) {
            if (xhr.readyState == 0 || xhr.status == 0) {
                return; //Skip this error
            }
            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        },
        complete: complFunc
    });
}

//리스트안 체크박스 하나만 체크
function ListCheckboxOnlyOne(tableid) {
    $("#" + tableid).on("click", "input[type=checkbox]", function (eventData) {
        var checked = $(eventData.currentTarget).prop("checked");

        if (checked) {
            $("#" + tableid + " input[type=checkbox]").prop("checked", false);//uncheck everything.
            $(eventData.currentTarget).prop("checked", "checked");//recheck this one. 
        }
    });
}

//RealTime Comma찍기
function RealTimeComma(txt_id) {
    var value = "";
    $("#" + txt_id).on("change", function () {      
        value = $("#" + txt_id).val();
        value = value.replace(/[^\d]+/g, ''); // (,)지우기 
        $("#" + txt_id).val(numberWithCommas(value));
    });

    $("#" + txt_id).keyup(function () {
        value = $("#" + txt_id).val();
        value = value.replace(/[^\d]+/g, ''); // (,)지우기 
        $("#" + txt_id).val(numberWithCommas(value));
    });
}

//div레이어팝업
function layer_open(layerclass, el, width, height) {
    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수

    if (bg) {
        $('.' + layerclass).fadeIn();	//'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
    } else {
        temp.fadeIn();
    }

    // 화면의 중앙에 레이어를 띄운다.
    if (temp.outerHeight() < $(document).height()) temp.css('margin-top', '-' + temp.outerHeight() / 2 + 'px');
    else temp.css('top', '0px');
    if (temp.outerWidth() < $(document).width()) temp.css('margin-left', '-' + temp.outerWidth() / 2 + 'px');
    else temp.css('left', '0px');

    //팝업의 크기 정의
    temp.css('width', width);     
    temp.css('height', height);

    temp.find('a.cbtn').click(function (e) {
        if (bg) {
            $('.' + layerclass).fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        } else {
            temp.fadeOut();
        }
        e.preventDefault();
    });
}

//div레이어팝업 - 위치 지정 가능
function layer_position_open(layerclass, el, top, left, width, height) {
    
    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수

    if (bg) {
        $('.' + layerclass).fadeIn();	//'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
    } else {
        temp.fadeIn();
    }

    // 화면의 중앙에 레이어를 띄운다.
    if (left == "") {
        var centerWidth = temp.outerWidth() / 2 + 100;
        if (temp.outerWidth() < $(document).width()) temp.css('margin-left', '-' + centerWidth + 'px');
        else temp.css('left', '0px');
    } else {
        temp.css('left', left);
    }
    
    temp.css('top', top);
    
    //팝업의 크기 정의
    temp.css('width', width);
    temp.css('height', height);

    temp.find('a.cbtn').click(function (e) {
        if (bg) {
            $('.' + layerclass).fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        } else {
            temp.fadeOut();
        }
        e.preventDefault();
    });
}

//div레이어팝업 - 위치 지정 가능
function layer_popup_open(packageId, el, top, left, width, height) {

    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수

    if (bg) {
        $('#' + packageId).fadeIn();	//'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
    } else {
        temp.fadeIn();
    }

    // 화면의 중앙에 레이어를 띄운다.
    if (left == "") {
        var centerWidth = temp.outerWidth() / 2 + 100;
        if (temp.outerWidth() < $(document).width()) temp.css('margin-left', '-' + centerWidth + 'px');
        else temp.css('left', '0px');
    } else {
        temp.css('left', left);
    }

    temp.css('top', top);

    //팝업의 크기 정의
    temp.css('width', width);
    temp.css('height', height);

    temp.find('a.cbtn').click(function (e) {
        if (bg) {
            $('#' + packageId).fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        } else {
            temp.fadeOut();
        }
        e.preventDefault();
    });
}

//div팝업닫기
function fnClosePopup(id) {
    $('#'+id).fadeOut();
    return false;
}

//Javascript QueryString Get
function fnGetQueryStrings() {
    var assoc = {};
    var decode = function (s) { return decodeURIComponent(s.replace(/\+/g, " ")); };
    var queryString = location.search.substring(1);
    var keyValues = queryString.split('&');

    for (var i in keyValues) {
        var key = keyValues[i].split('=');
        if (key.length > 1) {
            assoc[decode(key[0])] = decode(key[1]);
        }
    }

    return assoc;
} 

//화폐단위
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 넘어온 값이 빈값인지 체크합니다.
// !value 하면 생기는 논리적 오류를 제거하기 위해 명시적으로 value == 사용
// [], {} 도 빈값으로 처리
function isEmpty(value) {
    if (value == "" || value == null || value == "null" || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)) {
        return true
    } else {
        return false
    }
};

//자바스크립트 datetype -yyyy-MM-dd 포맷변경 ex)  var date = new Date(); --> date.yyyymmdd()
Date.prototype.yyyymmdd = function () {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth() + 1).toString();
    var dd = this.getDate().toString();
    return yyyy + "-" + (mm[1] ? mm : '0' + mm[0]) + "-" + (dd[1] ? dd : '0' + dd[0]);
};

Date.prototype.format = function (f) {
    if (!this.valueOf()) return " ";

    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};


String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };


//페이징
function fnCreatePagination(containerId, totalCount, pageNum, pageSize, pageData) {

    var container = $('#' + containerId);
    var sources = function () {
        var result = [];
        for (var i = 1; i <= totalCount; i++) {
            result.push(i);
        }
        return result;
    }();

    var options = {
        dataSource: sources,
        pageNumber: pageNum,
        pageSize: pageSize,
        pageRange: 3,
        //hideWhenLessThanOnePage: true,
        //autoHidePrevious: true,
        //autoHideNext: true,
        afterGoButtonOnClick: function () {
            pageData();
        },
        afterPreviousOnClick: function () {
            pageData();
        },
        afterNextOnClick: function () {
            pageData();
        },
        afterPageOnClick: function () {
            pageData();

        }
    };

    container.pagination(options);

    return container;

}

function maxLengthCheck(object) {
    if (object.value.length > object.maxLength) {
        object.value = object.value.slice(0, object.maxLength);
    }
}

//노이미지 처리
function no_image(el, type) {
    var noimage = '';

    if (type == 's') {
        noimage = 'noImage_s.jpg';
    }
    else if (type == 'm') {
        noimage = 'noImage_m.jpg';
    }
    else if (type == 'o') {
        noimage = 'X.jpg';
    }
    else {
        noimage = 'noImage.jpg';
    }
    $(el).attr("src", '/Images/' + noimage+'');
}


//쿠키값 생성(쿠키명, 쿠키값, 쿠키유지일수(브라우저세션:''), 쿠키접속가능경로(전체:'/'), 도메인)
function fnSetCookie(cname, cvalue, exdays, pathVal, domainVal) {
    var cookieStr = '';
    cookieStr = cname + "=" + cvalue;

    var d = new Date();
    var expires = '';
    if (!isEmpty(exdays)) {
        d.setTime(d.getTime() + (Number(exdays) * 24 * 60 * 60 * 1000));
        expires = "expires=" + d.toGMTString() + ";";

        cookieStr += ";" + expires;
    }

    var path = '';
    if ((pathVal != null) && (pathVal != '')) {
        path = "path=" + pathVal + ";";

        cookieStr += path;
    }

    var domain = '';
    if ((domainVal != null) && (domainVal != '')) {
        domain = "domain=" + domainVal;

        cookieStr += domain;
    }
    document.cookie = cookieStr;
}

//쿠키값 읽기
function fnGetCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}


//쿠키 지우기
function fnDeleteCookie(name, path, domain) {

    var expireDate = new Date();

    //어제 날짜를 쿠키 소멸 날짜로 설정한다.
    expireDate.setDate(expireDate.getDate() - 1);

    if (fnGetCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? ";path=" + path : "") +
            ((domain) ? ";domain=" + domain : "") +
            ";expires=" + expireDate.toGMTString()+"";
    }
}

//오라클 데이터 타입 컨버터
function fnOracleDateFormatConverter(val) {

    var returnVal = '';
    if (val != null) {
        returnVal = val.split('T')[0];
    }
    return returnVal;

}


//공용 윈도우 팝업(중앙정렬)
function fnWindowOpen(url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar) {
    
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

    var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
    var top = ((getheight / 2) - (height / 2)) + dualScreenTop;
    
    var objWin  = window.open(url, target, "width=" + width + ",height=" + height + ",status=" + status + ",toolbar=" + toolbar + ",menubar=" + menubar + ",location=" + location + ",resizable=" + resizable + ", scrollbars=" + scrollbar + ",left=" + left + ", top=" + top + "");
    
    if (navigator.userAgent.indexOf("Chrome") > -1) {

    }
    else {
        if (typeof (objWin) == "undefined" || objWin == null || typeof (objWin.name) == "undefined") {
            alert("팝업 차단이 설정되어있습니다. 해제하고 다시 시도해 주세요.");
        }
    }
}

function chkID(str) {

    var reg1 = /^[a-zA-Z0-9]{6,16}$/;
    var reg2 = /[a-zA-Z]/g;
    var reg3 = /[0-9]/g;
    return (reg1.test(str) && reg2.test(str) && reg3.test(str));

}

//탭클릭 페이지리다이렉트
function fnTabClickRedirect(pageName) {
    location.href = pageName + '.aspx?ucode=' + ucode;
    return false;
}

function fnCheckArrayCotains(arr, element) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] == element) {
            return true;
        }
    }
    return false;
}

function fnArrayValRemove(arr) {
    var what, a = arguments, L = a.length, ax;
    while (L > 1 && arr.length) {
        what = a[--L];
        while ((ax = arr.indexOf(what)) !== -1) {
            arr.splice(ax, 1);
        }
    }
    return arr;
}



function fnOpenDivLayerPopup(id) {
    var e = document.getElementById(id);


    if (e.style.display == 'block') {
        e.style.display = 'none';

    }
    else {
        $(".popupdivWrapper").css('left', '0px');
        $(".popupdivWrapper").css('top', '0px');
        e.style.display = 'block';
        $(".popupdivWrapper").draggable();
    }
}


//매출내역 퀵메뉴 팝업
$(document).ready(function () {
    var currentPosition = parseInt($("#quick").css("top"));
    $(window).scroll(function () {
        var position = $(window).scrollTop(); // 현재 스크롤바의 위치값을 반환합니다.
        $("#quick").stop().animate({ "top": position + currentPosition + "px" }, 1000);
    });
});