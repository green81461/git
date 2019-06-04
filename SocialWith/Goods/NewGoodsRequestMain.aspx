<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="NewGoodsRequestMain.aspx.cs" Inherits="Goods_NewGoodsRequestMain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/SysList/system.css" rel="stylesheet" />
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    

    
    
    <script type="text/javascript">
        var rowCnt = 1;

        var is_sending = false;

        $(function () {

            //첫번째 Row카테고리 바인딩
            var callback = function (response) {

                if (!isEmpty(response)) {
                    var optionTag = ''
                    for (var i = 0; i < response.length; i++) {
                        optionTag += '<option value="' + response[i].CategoryFinalCode + '^' + response[i].MDName+'">' + response[i].CategoryFinalName + '</option>'
                    }
                    $('#slCategory_0').append('<option value="etc2">공사/용역/서비스</option>');
                    $('#slCategory_0').append(optionTag);
                  
                    $('#slCategory_0').append('<option value="etc">기타</option>');
                    

                }
                return false;
            };

            var param = { Method: 'GetCategoryParentList' };



            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%= Svid_User%>');

        })

        // 행 추가
        function fnRowAdd() {


            var callback = function (response) {

                if (!isEmpty(response)) {

                    var addRow = '<tr alt="rowindex_' + rowCnt + '">';
                    addRow += '<td class="border-right">';
                    addRow += '<select id="slCategory_' + rowCnt + '" style="width: 200px" class="txtInput">';
                    addRow += '<option value= "etc2" >공사/용역/서비스</option>';
                    for (var i = 0; i < response.length; i++) {

                        addRow += '<option value="' + response[i].CategoryFinalCode + '^' + response[i].MDName+'">' + response[i].CategoryFinalName + '</option>';
                    }
                    addRow += '<option value= "etc" > 기타</option>';
                    addRow += '</select>';
                    addRow += '</td>';
                    addRow += '<td class="border-right">';
                    addRow += '<input type="text" id="txtOptionvalues_' + rowCnt + '" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right" rowspan="2">';
                    addRow += '<input type="text" id="txtModel_' + rowCnt + '" style="width: 100px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right">';
                    addRow += '<input type="text" id="txtOrigin_' + rowCnt + '" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right" rowspan="2">';
                    addRow += '<input type="text" id="txtProspectQty_' + rowCnt + '" style="width: 50px; ime-mode:disabled;" onkeypress="return onlyNumbers(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right" rowspan="2">';
                    addRow += '<input type="text" id="txtNewGoodsPriceVat_' + rowCnt + '" style="width: 70px; ime-mode:disabled;" onkeypress="return onlyNumbers(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right" rowspan="2">';
                    addRow += '<textarea rows="5" id="txtDetail_' + rowCnt + '" style="width:100%; border:1px solid #a2a2a2" ></textarea>';
                    addRow += '</td>';
                    addRow += '<td class="border-right" rowspan="2">';
                    addRow += '<textarea rows="5" id="txtRequest_' + rowCnt + '" style="width:100%; border:1px solid #a2a2a2" ></textarea>';
                    addRow += '</td>';
                    addRow += '<td class="" rowspan="2">';
                    addRow += '<input  type="file" id="fileUpload_' + rowCnt + '" style="width: 180px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '</tr>';

                    addRow += '<tr>';
                    addRow += '<td class="border-right">';
                    addRow += '<input type="text" id="txtGoodsName_' + rowCnt + '" style="width: 200px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right">';
                    addRow += '<input type="text" id="txtBrandName_' + rowCnt + '"  style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '<td class="border-right">';
                    addRow += '<input type="text" id="txtUnitName_' + rowCnt + '" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>';
                    addRow += '</td>';
                    addRow += '</tr>';

                    $('#tblTbody').append(addRow);

                    rowCnt++;

                }
                return false;
            };

            var param = { Method: 'GetCategoryParentList' };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%= Svid_User%>');



        }

        //행삭제
        function fnRowDelete() {
            var rowCnt = $("#tblTbody tr").length;
            if (rowCnt <= 2) {
                alert("더이상 삭제할 수 없습니다.");
                return false;
            }

            $('#tblTbody tr:last').remove();
            $('#tblTbody tr:last').remove();
            rowCnt--;
            return false;
        }

        //저장
        function fnSave() {

            var resultCode = '';
            var checkIndex = 0;
            var goodsCheckFlag = true;
            var optionCheckFlag = true;
            var brandCheckFlag = true;
            var modelCheckFlag = true;
            var prospectCheckFlag = true;
            var unitCheckFlag = true;


            $("#tblTbody tr[alt^=rowindex_]").each(function () {

                var ctgyCode = $(this).children().find("select[id^=slCategory_]").val();
                var optionVal = $(this).children().find("input[id^=txtOptionvalues_]").val();
                var model = $(this).children().find("input[id^=txtModel_]").val();
                var brand = $(this).children().find("input[id^=txtBrand_]").val();
                var prospectQty = $(this).children().find("input[id^=txtProspectQty_]").val();
                var priceVat = $(this).children().find("input[id^=txtNewGoodsPriceVat_]").val();
                var goodsName = $(this).next().children().find("input[id^=txtGoodsName_]").val();
                var brandName = $(this).next().children().find("input[id^=txtBrandName_]").val();
                var unitName = $(this).next().children().find("input[id^=txtUnitName_]").val();


                if (goodsName == '') {

                   // $('#txtGoodsName_' + checkIndex).focus();
                    goodsCheckFlag = false;

                }
                if (optionVal == '') {

                    //$('#txtOptionvalues_' + checkIndex).focus();
                    optionCheckFlag = false;

                }
                if (brand == '') {

                   // $('#txtBrand_' + checkIndex).focus();
                    brandCheckFlag = false;

                }
                if (model == '') {

                   // $('#txtModel_' + checkIndex).focus();
                    modelCheckFlag = false;

                }
                if (prospectQty == '') {

                  //  $('#txtProspectQty_' + checkIndex).focus();
                    prospectCheckFlag = false;

                }

                if (unitName == '') {

                    unitCheckFlag = false;
                }
                checkIndex++;
            });

            if (!goodsCheckFlag) {
                alert('상품명은 필수입력 값입니다.');
                return false;
            }
            if (!optionCheckFlag) {
                alert('규격은 필수입력 값입니다.');
                return false;
            }
            //if (!brandCheckFlag) {
            //    alert('제조사는 필수입력 값입니다.');
            //    return false;
            //}
            //if (!modelCheckFlag) {
            //    alert('모델명은 필수입력 값입니다.');
            //    return false;
            //}
            if (!prospectCheckFlag) {
                alert('예상구매수량은 필수입력 값입니다.');
                return false;

            }
            if (!unitCheckFlag) {
                alert('단위는 필수입력 값입니다.');
                return false;

            }


            var uploads = $('input[id^="fileUpload"]');
            var validFilesTypes = '<%= ConfigurationManager.AppSettings["AllowExtention"]%>';
            var maxFileSize = '<%= ConfigurationManager.AppSettings["UploadFileMaxSize"]%>';
            var sizeExcessFlag = true;
            $.each(uploads, function (key, value) {
                if ($(this).val() != '') {
                    if ( $(this)[0].files[0] != null) {
                        if ($(this)[0].files[0].size > maxFileSize) {

                            sizeExcessFlag = false
                            return false;
                        }
                    }

                }
            });

            if (!sizeExcessFlag) {
                alert('파일 용량은 10MB보다 작아야 합니다.');
                return false;
            }
            if (!confirm('저장하시겠습니까?')) {
                return false;
            }

            var index = 1;
            var rowcnt = $("#tblTbody tr[alt^=rowindex_]").length;

            $("#tblTbody tr[alt^=rowindex_]").each(function () {
                var getFiles = $(this).children().find("input[id^=fileUpload_]").get(0).files;

                var callback = function (response) {
                    if (!isEmpty(response)) {
                        fnFileupload(getFiles, response.split('//')[0], response.split('//')[1]);
                    }
                    return false;
                };

                var ctgyCode = $(this).children().find("select[id^=slCategory_]").find('option:selected').val();
                var ctgyName = $(this).children().find("select[id^=slCategory_]").find('option:selected').text();
                var optionVal = $(this).children().find("input[id^=txtOptionvalues_]").val();
                var model = $(this).children().find("input[id^=txtModel_]").val();
                var origin = $(this).children().find("input[id^=txtOrigin_]").val();
                var prospectQty = $(this).children().find("input[id^=txtProspectQty_]").val();
                var priceVat = $(this).children().find("input[id^=txtNewGoodsPriceVat_]").val();
                var detail = $(this).children().find("textarea[id^=txtDetail_]").val();
                var request = $(this).children().find("textarea[id^=txtRequest_]").val();
                var upload = $(this).children().find("input[id^=fileUpload_]").val();
                var goodsName = $(this).next().children().find("input[id^=txtGoodsName_]").val();
                var brandName = $(this).next().children().find("input[id^=txtBrandName_]").val();
                var unitName = $(this).next().children().find("input[id^=txtUnitName_]").val();
                var uploadflag = 'N';

                if (upload != '') {
                    uploadflag = 'Y'
                }
                var param = {
                    SvidUser: '<%= Svid_User%>',
                    UserId: '<%= UserId%>',
                    CategoryCode: ctgyCode.split('^')[0],
                    CategoryName: ctgyName,
                    MdName: ctgyCode.split('^')[1],
                    GoodsName: goodsName,
                    OptionValue: optionVal,
                    BrandName: brandName,
                    Model: model,
                    OriginName: origin,
                    UnitName: unitName,
                    Qty: prospectQty,
                    Price: priceVat,
                    Detail: detail,
                    ReqSubject: request,
                    FileFlag: uploadflag,
                    Method: 'InsertNewGood'
                };
                var sessionValue = '<%= Svid_User%>';
                if (sessionValue == "" || sessionValue == null) {
                    alert("로그인 연결이 끊겼습니다. 다시 로그인 해 주세요.");
                    location.href = '../../Member/Login.aspx';
                    return false;
                }

                $.ajax({
                    type: 'Post',
                    url: '../../Handler/GoodsHandler.ashx',
                    cache: false,
                    data: param,
                    dataType: 'text',
                    async: false,
                    success: callback,
                    error: function (xhr, status, error) {
                        if (xhr.readyState == 0 || xhr.status == 0) {
                            return; //Skip this error
                        }
                        alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                    }
                });
                index++;
            });
            location.href = 'NewGoodsRequestList.aspx';
            return false;
        }


        //
        function fnFileupload(files, attach, code) {

            var data = new FormData();
           
            // Add the uploaded image content to the form data collection
            if (files.length > 0) {
                data.append("UploadFile", files[0]);
                data.append("SvidAttach", attach);
                data.append("Code", code);
                data.append("Type", 'NewGood');
                data.append("Method", 'NewGoodFileUpload');
                data.append("UserId", '<%= UserId%>');
            }

            // Make Ajax request with the contentType = false, and procesDate = false
            var ajaxRequest = $.ajax({
                type: "POST",
                url: '../../Handler/FileUploadHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                data: data
            });

            ajaxRequest.done(function (xhr, textStatus) {


            });

            return false;
        }

        <%--function fnShowTextbox(divid, level) {

            if (event.keyCode == 13) {
                event.preventDefault();
                return false;
            }

            if (divid == 'detailTextDiv') {

                if ($('#txtDetail_' + level).val() == '') {
                    $('#<%= txtDetail.ClientID%>').val('');
                }
               
                $('#hdDetailLevel').val(level);
            }
            else {
                if ($('#txtRequest_' + level).val() == '') {
                    $('#<%= txtRequest.ClientID%>').val('');
                }

              
                $('#hdRequestLevel').val(level);
            }
            var e = document.getElementById(divid);

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;

        }

        function fnConfirm(type) {
            if (type == 'detail') {
                var getDetaillevel = $('#hdDetailLevel').val();
              
                var txtDetail = $('#<%= txtDetail.ClientID%>');
                $('#txtDetail_' + getDetaillevel).val(txtDetail.val());
                $('#hdDetail_' + getDetaillevel).val(txtDetail.val());
                fnClosePopup('detailTextDiv');
            }
            else {
                var getReqlevel = $('#hdRequestLevel').val();
                var txtRequest = $('#<%= txtRequest.ClientID%>');
                $('#txtRequest_' + getReqlevel).val(txtRequest.val());
                $('#hdRequest_' + getReqlevel).val(txtRequest.val());
                fnClosePopup('requestTextDiv');
            }
            return false;
        }--%>

        function fnUploadCompleteMsg() {
            alert('업로드 완료되었습니다.');
            location.href = 'NewGoodsRequestList.aspx';
            return false;

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목영역-->
            <div class="sub-title-div">
                   <img src="/images/NewGoodsRequestMain_nam.png" /> 
                <%--<p class="p-title-mainsentence">신규견적요청 
                </p>--%>
            </div>

             <!--탭영역-->
            
            <div class="div-main-tab">
                <ul>
                    <li class='tabOn' onclick="location.href='NewGoodsRequestMain.aspx'">
                        <a href="NewGoodsRequestMain.aspx" style="display: block">신규견적요청</a>
                    </li>
                    <li class='tabOff' onclick="location.href='NewGoodsRequestList.aspx'">
                        <a href="NewGoodsRequestList.aspx" style="display: block">요청현황</a>
                    </li>
                </ul>
            </div>
            
            <div style="margin-top: 30px;">
                <!--행추가,행삭제 영역-->
                <div style="text-align: left; display:inline">
                    <input type='button' class='subBtn' value='행추가' style='width:71px; height:22px; font-size:12px' onclick='fnRowAdd(); return false;'/>
                    <input type='button' class='subBtn' value='행삭제' style='width:71px; height:22px; font-size:12px' onclick='fnRowDelete(); return false;'/>
                    <%--<asp:ImageButton runat="server" AlternateText="행추가" ImageUrl="../Images/Goods/rowAdd-off.jpg" onmouseover="this.src='../Images/Goods/rowAdd-on.jpg'" onmouseout="this.src='../Images/Goods/rowAdd-off.jpg'" OnClientClick="fnRowAdd(); return false;" />
                    <asp:ImageButton runat="server" AlternateText="행삭제" ImageUrl="../Images/Goods/rowDel-off.jpg" onmouseover="this.src='../Images/Goods/rowDel-on.jpg'" onmouseout="this.src='../Images/Goods/rowDel-off.jpg'" OnClientClick="fnRowDelete(); return false;" />--%>
                </div>
                <!--엑셀 파일 등록-->
                <div class="fileDiv" style="margin-bottom:30px; height:30px; float:right; display:inline">
                
                    <table class="fileTbl" >
                        <tr><th style="width:200px">엑셀파일 등록</th>
                            <td><asp:FileUpload runat="server" ID="fuExcel" CssClass="excelfileupload" Width="400px"/></td>
                            <td style="border-right:none; ">
                                <asp:Button runat="server" ID="btnExcelUpload" Text="엑셀업로드" CssClass="commonBtn" Font-Size="12px" Width="95px" Height="30px" OnClick="btnExcelUpload_Click"/>
                            </td>
                            <td style="border-left:none;">
                                <asp:Button runat="server" ID="btnExcelFormDownload" Text="엑셀업로드폼 다운로드" CssClass="commonBtn" Font-Size="12px" Width="150px" Height="30px" OnClick="btnExcelFormDownload_Click"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <!--테이블영역-->
            <table class="tbl_main tbl_main2" style="width:100%">
                <thead>
                    <tr>
                        <th style="width: 200px" class="border-right">카테고리</th>
                        <th style="width: 80px" class="border-right">규격</th>
                        <th style="width: 100px" rowspan="2" class="border-right">모델명</th>
                        <th style="width: 80px" class="border-right">원산지</th>
                        <th style="width: 50px" rowspan="2" class="border-right">예상<br />
                            구매수량</th>
                        <th style="width: 70px" rowspan="2" class="border-right">기존단가</th>
                        <th style="width: 200px" rowspan="2" class="border-right">품목<br />
                            상세설명</th>
                        <th style="width: 200px" rowspan="2" class="border-right">요청사항</th>
                        <th style="width: 180px" rowspan="2">첨부파일</th>
                    </tr>
                    <tr>
                        <th style="" class="border-right">상품명</th>
                        <th style="" class="border-right">제조사</th>
                        <th style="" class="border-right">단위</th>
                    </tr>
                </thead>
                <tbody id="tblTbody">
                    <tr alt="rowindex_0">
                        <td class="border-right">
                            <select id="slCategory_0" style="width: 200px" class="txtInput"></select>
                        </td>
                        <td class="border-right">
                            <input type="text" id="txtOptionvalues_0" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput" />
                        </td>
                        <td class="border-right" rowspan="2">
                            <input type="text" id="txtModel_0" style="width: 100px" onkeypress="preventEnter(event);" class="txtInput"/>
                        </td>
                        <td class="border-right">
                            <input type="text" id="txtOrigin_0" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>
                        </td>
                        <td class="border-right" rowspan="2">
                            <input type="text" id="txtProspectQty_0" style="width: 50px; ime-mode:disabled;" onkeypress="return onlyNumbers(event);" class="txtInput"/>
                        </td>
                        <td class="border-right" rowspan="2">
                            <input type="text" id="txtNewGoodsPriceVat_0" style="width: 70px; ime-mode:disabled;" onkeypress="return onlyNumbers(event);" class="txtInput"/>
                        </td>
                       <%-- <td class="txt-center" rowspan="2">
                            <input type="text" id="txtDetail_0" style="width: 200px" onkeypress="preventEnter(event); return false;"  onclick="return fnShowTextbox('detailTextDiv',0);" />
                            <input type="hidden" id="hdDetail_0"" />
                        </td>
                        <td class="txt-center" rowspan="2">
                            <input type="text" id="txtRequest_0" style="width: 200px" onkeypress="preventEnter(event); return false;" onclick="return fnShowTextbox('requestTextDiv',0);"/>
                            <input type="hidden" id="hdRequest_0"" />
                        </td>--%>
                         <td class="border-right" rowspan="2">
                            <textarea class="textbox" rows="5" id="txtDetail_0"></textarea>
                        </td>
                        <td class="border-right" rowspan="2">
                            <textarea class="textbox" rows="5" id="txtRequest_0"></textarea>
                        </td>
                        <td rowspan="2">
                            <input type="file" id="fileUpload_0" style="width: 180px" onkeypress="preventEnter(event);"  class="txtInput"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="border-right">
                            <input type="text" id="txtGoodsName_0" style="width: 200px" onkeypress="preventEnter(event);" class="txtInput"/>
                        </td>
                        <td class="border-right">
                            <input type="text" id="txtBrandName_0" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>
                        </td>
                        <td class="border-right">
                            <input type="text" id="txtUnitName_0" style="width: 80px" onkeypress="preventEnter(event);" class="txtInput"/>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div style="text-align: right; margin-top: 30px; margin-bottom: 10px;">
                <input type="button" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="요청하기" onclick="return fnSave();"/>
               <%-- <asp:ImageButton runat="server" AlternateText="엑셀일괄등록" ImageUrl="../Images/Goods/excellTotal-off.jpg" onmouseover="this.src='../Images/Goods/excellTotal-on.jpg'" onmouseout="this.src='../Images/Goods/excellTotal-off.jpg'" />--%>
                <%--<asp:ImageButton runat="server" AlternateText="요청하기" ImageUrl="../Images/Goods/req-off.jpg" onmouseover="this.src='../Images/Goods/req-on.jpg'" onmouseout="this.src='../Images/Goods/req-off.jpg'" OnClientClick="return fnSave();" />--%>

            </div>
            <div class="left-menu-wrap" id="divLeftMenu">
                <dl>
                    <dt>
                        <strong>주문정보</strong>
                    </dt>
                    <dd>
                                <a href="/Cart/CartList.aspx">장바구니</a>
                    </dd>
                    <dd>
                        <a href="/Wish/WishList.aspx">위시상품 리스트</a>
                    </dd>
                    <dd>
                        <a href="/Goods/GoodsRecommListSearch.aspx">견적상품게시판</a>
                    </dd>
                    <dd class="active">
                        <a href="/Goods/NewGoodsRequestMain.aspx">신규견적요청</a>
                    </dd>
                </dl>
        </div>
        </div>
    </div>
</asp:Content>

