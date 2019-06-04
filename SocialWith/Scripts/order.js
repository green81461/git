/**
 * 주문(A/S 포함) 관련 기능
 * @param {any} tagId
 * @param {any} paywayVal
 */

//[주문하기]결제방식 선택 영역 내용 설정
function fnSetPaywayView(tagId, paywayVal) {
            
    if (isEmpty(paywayVal)) {
        alert("결제방식을 설정할 수 없습니다. 창을 닫고 다시 시도해 주세요.");
        return false;
    }

    $("#" + tagId).empty();
    var payTag = "";
            
    var posArr = new Array();
    var pos = paywayVal.indexOf("1");

    while (pos > -1) {
        posArr.push(pos);
        pos = paywayVal.indexOf("1", pos + 1);
    }
            
    for (var i = 0; i < posArr.length; i++) {

        switch (posArr[i]) {
            case 1:
                payTag += "<input type='radio' value='1' name='pay' checked='checked' />&nbsp;신용카드&nbsp;&nbsp;";
                break;
            case 2:
                payTag += "<input type='radio' value='2' name='pay' />&nbsp;실시간계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 3:
                payTag += "<input type='radio' value='3' name='pay' />&nbsp;가상계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 4:
                payTag += "<input type='radio' value='4' name='pay' />&nbsp;후불계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 5:
                payTag += "<input type='radio' value='5' name='pay' />&nbsp;ARS(신용카드결제)&nbsp;&nbsp;";
                break;
            case 6:
                //payTag += "<input type='radio' value='6' name='pay' />&nbsp;여신결제(일반)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='6' name='pay' />&nbsp;여신결제<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 7:
                //payTag += "<input type='radio' value='7' name='pay' />&nbsp;여신결제(판매분)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='7' name='pay' />&nbsp;여신결제&nbsp;&nbsp;";
                break;
            case 8:
                //payTag += "<input type='radio' value='8' name='pay' />&nbsp;여신결제(무)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='8' name='pay' />&nbsp;여신결제&nbsp;&nbsp;";
                break;
            case 9:
                //payTag += "<input type='radio' value='9' name='pay' />&nbsp;가상계좌(고정)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='9' name='pay' />&nbsp;후불계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 10:
                //payTag += "<input type='radio' value='8' name='pay' />&nbsp;여신결제(무)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='10' name='pay' />&nbsp;무통장입금<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
        }

        if (i === 3) payTag += "<br />";
    }
            
    $("#" + tagId).html(payTag);

    $("#" + tagId + " input:first-child[type='radio']").prop("checked", true);
}

//[A/S결제]결제방식 선택 영역 내용 설정
function fnSetASPaywayView(tagId, paywayVal) {

    if (isEmpty(paywayVal)) {
        alert("결제방식을 설정할 수 없습니다. 창을 닫고 다시 시도해 주세요.");
        return false;
    }

    $("#" + tagId).empty();
    var payTag = "";

    var posArr = new Array();
    var pos = paywayVal.indexOf("1");

    while (pos > -1) {
        posArr.push(pos);
        pos = paywayVal.indexOf("1", pos + 1);
    }

    for (var i = 0; i < posArr.length; i++) {

        switch (posArr[i]) {
            case 1:
                payTag += "<input type='radio' value='21' name='pay' checked='checked' />&nbsp;신용카드&nbsp;&nbsp;";
                break;
            case 2:
                payTag += "<input type='radio' value='22' name='pay' />&nbsp;실시간계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 3:
                payTag += "<input type='radio' value='23' name='pay' />&nbsp;가상계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 4:
                payTag += "<input type='radio' value='24' name='pay' />&nbsp;후불계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 5:
                payTag += "<input type='radio' value='25' name='pay' />&nbsp;ARS(신용카드결제)&nbsp;&nbsp;";
                break;
            case 6:
                //payTag += "<input type='radio' value='26' name='pay' />&nbsp;여신결제(일반)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='26' name='pay' />&nbsp;여신결제<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 7:
                //payTag += "<input type='radio' value='27' name='pay' />&nbsp;여신결제(판매분)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='27' name='pay' />&nbsp;여신결제&nbsp;&nbsp;";
                break;
            case 8:
                //payTag += "<input type='radio' value='28' name='pay' />&nbsp;여신결제(무)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='28' name='pay' />&nbsp;여신결제&nbsp;&nbsp;";
                break;
            case 9:
                //payTag += "<input type='radio' value='29' name='pay' />&nbsp;가상계좌(고정)&nbsp;&nbsp;";
                payTag += "<input type='radio' value='29' name='pay' />&nbsp;후불계좌<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;";
                break;
            case 10:
                payTag += "<input type='radio' value='20' name='pay' />&nbsp;무통장입금<span style='color: #804000; padding-left: 3px; font-weight: bold;'>#</span>&nbsp;&nbsp;"; //payway 값을 임시로 설정함. 나중에 다시 설정해야 함.
                break;
        }

        if (i === 3) payTag += "<br />";
    }

    $("#" + tagId).html(payTag);
}

//결제수단 검색 조건 설정
function fnSetPaywaySearch(tagId, paywayVal) {
    if (isEmpty(paywayVal)) {
        alert("결제수단을 설정할 수 없습니다. 창을 닫고 다시 시도해 주세요.");
        return false;
    }

    $("#" + tagId).empty();
    var payTag = "<option value='ALL'>---전체---</option>";

    var posArr = new Array();
    var pos = paywayVal.indexOf("1");

    while (pos > -1) {
        posArr.push(pos);
        pos = paywayVal.indexOf("1", pos + 1);
    }

    for (var i = 0; i < posArr.length; i++) {

        switch (posArr[i]) {
            case 1:
                payTag += "<option value='1'>신용카드</option>";
                break;
            case 2:
                payTag += "<option value='2'>실시간계좌</option>";
                break;
            case 3:
                payTag += "<option value='3'>가상계좌</option>";
                break;
            case 4:
                payTag += "<option value='4'>후불계좌</option>";
                break;
            case 5:
                payTag += "<option value='5'>ARS(신용카드결제)</option>";
                break;
            case 6:
                payTag += "<option value='6'>여신결제</option>";
                break;
            case 7:
                payTag += "<option value='7'>여신결제</option>";
                break;
            case 8:
                payTag += "<option value='8'>여신결제</option>";
                break;
            case 9:
                payTag += "<option value='9'>후불계좌</option>";
                break;
            case 10:
                payTag += "<option value='10'>무통장입금</option>";
                break;
        }
    }

    $("#" + tagId).html(payTag);
}
