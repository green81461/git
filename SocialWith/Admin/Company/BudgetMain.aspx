<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BudgetMain.aspx.cs" Inherits="Admin_Company_BudgetMain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <style>
        .hovering {
            background: gainsboro;
        }

        #tblBudgetList th {
            background-color: #ececec;
            border: 1px solid #a2a2a2;
            height: 30PX;
        }

        #tblBudgetList td {
            border: 1px solid #a2a2a2;
            height: 30px;
        }

        #tblBudgetInfo th {
            background-color: #ececec;
            border: 1px solid #a2a2a2;
            height: 30PX;
        }

        #tblBudgetInfo td {
            border: 1px solid #a2a2a2;
            height: 30px;
        }


        #tblModifyList th {
            background-color: #ececec;
            border: 1px solid #a2a2a2;
            height: 30PX;
        }

        #tblModifyList td {
            border: 1px solid #a2a2a2;
            height: 30PX;
        }

        #tblSearch th {
            background-color: #ececec;
            border: 1px solid #a2a2a2;
            height: 30PX;
        }

        #tblSearch td {
            border: 1px solid #a2a2a2;
            height: 30px;
        }

        #tblModify th {
            background-color: #ececec;
            border: 1px solid #a2a2a2;
            height: 30PX;
        }

        #tblModify td {
            border: 1px solid #a2a2a2;
            height: 30px;
        }


        .notice-search-table th {
            border: 1px solid #a2a2a2;
            padding-left: 10px;
            padding-right: 10px;
        }

        .notice-search-table td {
            border: 1px solid #a2a2a2;
        }


        #tblBudgetList td {
            padding-left: 10px;
        }
    </style>
    <script type="text/javascript">

        $(function () {
            fnBudgetListBind(1);
        })

        //예산 리스트 바인드
        function fnBudgetListBind(pageNo) {
            $('#tblBudgetList tbody').empty(); //테이블 클리어

            $('#tblBudgetInfo tbody').empty(); //디테일테이블 클리어
            $('#tblBudgetInfo tbody').append('<tr><td colspan="9" class="txt-center">조회된 데이터가 없습니다.</td></tr>');
            var callback = function (response) {
                if (!isEmpty(response)) {
                    var newRowContent = '';

                    for (var i = 0; i < response.length; i++) {

                        var index = parseInt(i) + 1;
                        $('#hdTotalCount').val(response[i].TotalCount);
                        newRowContent += "<tr id='tablerow' class='fullrow row" + index + "' data-id='" + index + "'>";
                        newRowContent += "<td class='txt-center' rowspan='2'><input type='checkbox' id='cbSelect'/>";
                        newRowContent += "<input type='hidden' id='hdYear' value='" + response[i].Year + "'/>";
                        newRowContent += "<input type='hidden' id='hdMonth' value='" + response[i].Month + "'/>";
                        newRowContent += "<input type='hidden' id='hdCompNo' value='" + response[i].Company_No + "'/>";
                        newRowContent += "<input type='hidden' id='hdUniqueNo' value='" + response[i].Unique_No + "'/>";
                        newRowContent += "<input type='hidden' id='hdCompCode' value='" + response[i].Company_Code + "'/>";
                        newRowContent += "<input type='hidden' id='hdAreaCode' value='" + response[i].CompanyArea_Code + "'/>";
                        newRowContent += "<input type='hidden' id='hdBdeptCode' value='" + response[i].CompBusinessDept_Code + "'/>";
                        newRowContent += "<input type='hidden' id='hdDeptCode' value='" + response[i].CompanyDeptCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdModiUserName' value='" + response[i].ModiUserName + "'/>";
                        newRowContent += "<input type='hidden' id='hdUpdateDate' value='" + response[i].UpdateDate + "'/>";
                        newRowContent += "<input type='hidden' id='hdRemark' value='" + response[i].Remark + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetCost' value='" + response[i].BudgetCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetCarriedCost' value='" + response[i].BudgetCarriedCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetTotalCost' value='" + response[i].BudgetTotalCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetRemainCost' value='" + response[i].BudgetRemainCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdEntryDate' value='" + response[i].EntryDate + "'/>";
                        newRowContent += "<input type='hidden' id='hdUserName' value='" + response[i].UserName + "'/>";
                        newRowContent += "<input type='hidden' id='hdSvidUser' value='" + response[i].Svid_User + "'/>";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2' onClick='fnShowDetail(this);'>" + response[i].RowNum + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2' onClick='fnShowDetail(this);'>" + response[i].Year + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2' onClick='fnShowDetail(this);'>" + response[i].Month + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].Company_Code + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].CompanyArea_Code + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].CompBusinessDept_Code + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].CompanyDeptCode + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";

                        newRowContent += "<tr id='tablerow'  class='fullrow row" + index + "' data-id='" + index + "'>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].Company_Name + "";
                        newRowContent += "<input type='hidden' id='hdYear' value='" + response[i].Year + "'/>";
                        newRowContent += "<input type='hidden' id='hdMonth' value='" + response[i].Month + "'/>";
                        newRowContent += "<input type='hidden' id='hdCompNo' value='" + response[i].Company_No + "'/>";
                        newRowContent += "<input type='hidden' id='hdUniqueNo' value='" + response[i].Unique_No + "'/>";
                        newRowContent += "<input type='hidden' id='hdCompCode' value='" + response[i].Company_Code + "'/>";
                        newRowContent += "<input type='hidden' id='hdAreaCode' value='" + response[i].CompanyArea_Code + "'/>";
                        newRowContent += "<input type='hidden' id='hdBdeptCode' value='" + response[i].CompBusinessDept_Code + "'/>";
                        newRowContent += "<input type='hidden' id='hdDeptCode' value='" + response[i].CompanyDeptCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdModiUserName' value='" + response[i].ModiUserName + "'/>";
                        newRowContent += "<input type='hidden' id='hdUpdateDate' value='" + response[i].UpdateDate + "'/>";
                        newRowContent += "<input type='hidden' id='hdRemark' value='" + response[i].Remark + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetCost' value='" + response[i].BudgetCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetCarriedCost' value='" + response[i].BudgetCarriedCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetTotalCost' value='" + response[i].BudgetTotalCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdBudgetRemainCost' value='" + response[i].BudgetRemainCost + "'/>";
                        newRowContent += "<input type='hidden' id='hdEntryDate' value='" + response[i].EntryDate + "'/>";
                        newRowContent += "<input type='hidden' id='hdUserName' value='" + response[i].UserName + "'/>";
                        newRowContent += "<input type='hidden' id='hdSvidUser' value='" + response[i].Svid_User + "'/>";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].CompanyArea_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].CompBusinessDept_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' onClick='fnShowDetail(this);'>" + response[i].CompanyDeptName + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";
                    }
                    $('#tblBudgetList tbody').append(newRowContent);

                }
                else {
                    $("#hdTotalCount").val(0);
                    $('#tblBudgetList tbody').append('<tr><td colspan="8" class="txt-center">조회된 데이터가 없습니다.</td></tr>');
                }

                $(".fullrow").hover(function () {
                    var id = this.getAttribute("data-id");
                    $(".row" + id).addClass("hovering");
                    $(".row" + id).css('cursor', 'pointer')
                }).on("blur mouseleave", function () {
                    var id = this.getAttribute("data-id");
                    $(".row" + id).removeClass("hovering");
                });
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 10, getPageData);

                return false;
            }
            var param = {
                Method: 'AdminBudgetList',
                Keyword1: $('#txtKeyword1').val(),
                Keyword2: $('#txtKeyword2').val(),
                Keyword3: $('#txtKeyword3').val(),
                Keyword4: $('#txtKeyword4').val(),
                Target1: $('#select1').val(),
                Target2: $('#select2').val(),
                Target3: $('#select3').val(),
                Target4: $('#select4').val(),
                PageNo: pageNo,
                PageSize: 10

            };
            Jajax('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'json', callback);
        }




        //하단 예산 상세보기 
        function fnShowDetail(el) {

            var hdYear = $(el).parent().find('#hdYear').val();
            var hdMonth = $(el).parent().find('#hdMonth').val();
            var hdCompNo = $(el).parent().find('#hdCompNo').val();
            var hdUniqueNo = $(el).parent().find('#hdUniqueNo').val();
            var hdCompCode = $(el).parent().find('#hdCompCode').val();
            var hdAreaCode = $(el).parent().find('#hdAreaCode').val();
            var hdBdeptCode = $(el).parent().find('#hdBdeptCode').val();
            var hdDeptCode = $(el).parent().find('#hdDeptCode').val();

            var hdModiUserName = $(el).parent().find('#hdModiUserName').val();
            var hdUpdateDate = $(el).parent().find('#hdUpdateDate').val();
            var hdRemark = $(el).parent().find('#hdRemark').val();
            var hdBudgetCost = $(el).parent().find('#hdBudgetCost').val();
            var hdBudgetCarriedCost = $(el).parent().find('#hdBudgetCarriedCost').val();
            var hdBudgetTotalCost = $(el).parent().find('#hdBudgetTotalCost').val();
            var hdBudgetRemainCost = $(el).parent().find('#hdBudgetRemainCost').val();
            var hdEntryDate = $(el).parent().find('#hdEntryDate').val();
            var hdUserName = $(el).parent().find('#hdUserName').val();
            var hdSvidUser = $(el).parent().find('#hdSvidUser').val();


            $('#hdDetailYear').val(hdYear);
            $('#hdDetailMonth').val(hdMonth);
            $('#hdDetailCompNo').val(hdCompNo);
            $('#hdDetailUniqueNo').val(hdUniqueNo);
            $('#hdDetailCompCode').val(hdCompCode);
            $('#hdDetailAreaCode').val(hdAreaCode);
            $('#hdDetailBdeptCode').val(hdBdeptCode);
            $('#hdDetaildeptCode').val(hdDeptCode);

            $('#hdDetailModiUserName').val(hdModiUserName);
            $('#hdDetailUpdateDate').val(hdUpdateDate);
            $('#hdDetailRemark').val(hdRemark);
            $('#hdDetailBudgetCost').val(hdBudgetCost);
            $('#hdDetailBudgetCarriedCost').val(hdBudgetCarriedCost);
            $('#hdDetailBudgetTotalCost').val(hdBudgetTotalCost);
            $('#hdDetailBudgetRemainCost').val(hdBudgetRemainCost);
            $('#hdDetailEntryDate').val(hdEntryDate);
            $('#hdDetailUserName').val(hdUserName);
            $('#hdDetailSvidUser').val(hdSvidUser);


            fnDetailInfoBind();
        }

        //예산 디테일 정보 바인딩
        function fnDetailInfoBind() {

            $('#tblBudgetInfo tbody').empty(); //테이블 클리어

            var updateDate = '';
            var entryDate = '';


            if ($('#hdDetailUpdateDate').val() != 'null') {
                updateDate = $('#hdDetailUpdateDate').val().split('T')[0];
            }
            if ($('#hdDetailEntryDate').val() != 'null') {
                entryDate = $('#hdDetailEntryDate').val().split('T')[0];
            }
            var newRowContent = '';
            newRowContent += "<tr>";
            newRowContent += "<td class='txt-center'>" + $('#hdDetailModiUserName').val() + "";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'> " + updateDate + "";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'><a onclick='fnShowModifyReasonPopup(this,1);' style='cursor:pointer; color:blue'>" + $('#hdDetailRemark').val() + "</a>";
            newRowContent += "<input type='hidden' id='hdYear2' value='" + $('#hdDetailYear').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdMonth2' value='" + $('#hdDetailMonth').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdCompNo2' value='" + $('#hdDetailCompNo').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdUniqueNo2' value='" + $('#hdDetailUniqueNo').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdCompCode2' value='" + $('#hdDetailCompCode').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdAreaCode2' value='" + $('#hdDetailAreaCode').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdBdeptCode2' value='" + $('#hdDetailBdeptCode').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdDeptCode2' value='" + $('#hdDetaildeptCode').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdBudgetCost2' value='" + $('#hdDetailBudgetCost').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdRemainCost2' value='" + $('#hdDetailBudgetRemainCost').val() + "'/>";
            newRowContent += "<input type='hidden' id='hdSvidUser2' value='" + $('#hdDetailSvidUser').val() + "'/>";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'><a onclick='fnBudgetModifyPopup(this);' style='cursor:pointer; color:red'>" + numberWithCommas($('#hdDetailBudgetCost').val()) + "원</a>";
            newRowContent += "<input type='hidden' id='hdBudgetCost2' value='" + $('#hdDetailBudgetCost').val() + "'/>";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'>" + numberWithCommas($('#hdDetailBudgetCarriedCost').val()) + "원";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'>" + numberWithCommas($('#hdDetailBudgetTotalCost').val()) + "원";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'>" + numberWithCommas($('#hdDetailBudgetRemainCost').val()) + "원";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'>" + $('#hdDetailUserName').val() + "";
            newRowContent += "</td>";
            newRowContent += "<td class='txt-center'>" + entryDate + "";
            newRowContent += "</td>";
            newRowContent += "</tr>";


            $('#tblBudgetInfo tbody').append(newRowContent);

        }

        //예산 변경 이력 팝업
        function fnShowModifyReasonPopup(el, pageNo) {

            $('#hdPopupYear').val('');
            $('#hdPopupMonth').val('');
            $('#hdPopupCompNo').val('');
            $('#hdPopupUniqueNo').val('');
            $('#hdPopupCompCode').val('');
            $('#hdPopupAreaCode').val('');
            $('#hdPopupBdeptCode').val('');
            $('#hdPopupdeptCode').val('');
            $('#hdPopupSvidUser').val('');

            $('#ckbSearch1').prop("checked", true);
            $('#ckbSearch2').prop("checked", false);
            $('#ckbSearch3').prop("checked", false);
            $('#txtPopupSearch').val('');

            var tableid = 'tblSearch';
            ListCheckboxOnlyOne(tableid);

            var date = new Date();
            var dayOfMonth = date.getDate();
            date.setDate(dayOfMonth - 7)


            //상품검색창에서 달력 관련 기능
            $("#searchStartDate").val(date.yyyymmdd())
            $("#searchStartDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                beforeShow: function () {
                    $(this).css({
                        "position": "relative",
                        "z-index": '999999'
                    });
                },
            })


            $("#searchEndDate").val((new Date()).yyyymmdd())
            $("#searchEndDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: /*"/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                beforeShow: function () {
                    $(this).css({
                        "position": "relative",
                        "z-index": '999999'
                    });
                },
            })

            //검색창 날짜범위 선택 부분..
            $('#tblSearch input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#searchEndDate").val());
                    var resultDate = new Date();
                    resultDate.setDate(newDate.getDate() - num);
                    $("#searchStartDate").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });

            var hdYear = $(el).parent().find('#hdYear2').val();
            var hdMonth = $(el).parent().find('#hdMonth2').val();
            var hdCompNo = $(el).parent().find('#hdCompNo2').val();
            var hdUniqueNo = $(el).parent().find('#hdUniqueNo2').val();
            var hdCompCode = $(el).parent().find('#hdCompCode2').val();
            var hdAreaCode = $(el).parent().find('#hdAreaCode2').val();
            var hdBdeptCode = $(el).parent().find('#hdBdeptCode2').val();
            var hdDeptCode = $(el).parent().find('#hdDeptCode2').val();
            var hdSvidUser = $(el).parent().find('#hdSvidUser2').val();
            $('#hdPopupYear').val(hdYear);
            $('#hdPopupMonth').val(hdMonth);
            $('#hdPopupCompNo').val(hdCompNo);
            $('#hdPopupUniqueNo').val(hdUniqueNo);
            $('#hdPopupCompCode').val(hdCompCode);
            $('#hdPopupAreaCode').val(hdAreaCode);
            $('#hdPopupBdeptCode').val(hdBdeptCode);
            $('#hdPopupdeptCode').val(hdDeptCode);
            $('#hdPopupSvidUser').val(hdSvidUser);
            fnModifyReasonListBind(pageNo);

            var e = document.getElementById('modifyReasonDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
        }

        //예산 변경 이력 리스트 바인딩
        function fnModifyReasonListBind(pageNo) {

            $('#tblModifyList tbody').empty(); //테이블 클리어

            var callback = function (response) {
                if (response != null) {
                    var newRowContent = '';

                    for (var i = 0; i < response.length; i++) {


                        $('#hdModifyTotalCount').val(response[i].TotalCount);
                        newRowContent += "<tr>";
                        newRowContent += "<td class='txt-center'>" + response[i].Budget_Seq + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].Svid_UserName + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].EntryDate.split('T')[0] + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].Remark + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";


                    }
                    $('#tblModifyList tbody').append(newRowContent);

                }
                else {
                    $("#hdModifyTotalCount").val(0);
                    $('#tblModifyList tbody').append('<tr><td colspan="4" class="txt-center">조회된 데이터가 없습니다.</td></tr>');
                }
                fnCreatePagination('popuppagination', $("#hdModifyTotalCount").val(), pageNo, 10, getPopupPageData);

                return false;
            }


            var param = {
                Method: 'GetAdminBudgetModifyList',
                Keyword: $('#txtPopupSearch').val(),
                Sdate: $("#searchStartDate").val(),
                Edate: $("#searchEndDate").val(),
                Year: $('#hdPopupYear').val(),
                Month: $('#hdPopupMonth').val(),
                CompNo: $('#hdPopupCompNo').val(),
                UniqueNo: $('#hdPopupUniqueNo').val(),
                CompCode: $('#hdPopupCompCode').val(),
                CompAreaCode: $('#hdPopupAreaCode').val(),
                CompBDeptCode: $('#hdPopupBdeptCode').val(),
                CompDeptCode: $('#hdPopupdeptCode').val(),
                SvidUser: $('#hdPopupSvidUser').val(),
                PageNo: pageNo,
                PageSize: 10

            };
            Jajax('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'json', callback);


        }

        //예산 변경 팝업 창 활성화
        function fnBudgetModifyPopup(el) {
            var hdYear = $(el).parent().parent().find('#hdYear2').val();
            var hdMonth = $(el).parent().parent().find('#hdMonth2').val();
            var hdCompNo = $(el).parent().parent().find('#hdCompNo2').val();
            var hdUniqueNo = $(el).parent().parent().find('#hdUniqueNo2').val();
            var hdCompCode = $(el).parent().parent().find('#hdCompCode2').val();
            var hdAreaCode = $(el).parent().parent().find('#hdAreaCode2').val();
            var hdBdeptCode = $(el).parent().parent().find('#hdBdeptCode2').val();
            var hdDeptCode = $(el).parent().parent().find('#hdDeptCode2').val();
            var hdBudgetCost = $(el).parent().parent().find('#hdBudgetCost2').val();
            var hdRemainCost = $(el).parent().parent().find('#hdRemainCost2').val();
            var hdSvidUser = $(el).parent().parent().find('#hdSvidUser2').val();

            $('#hdPopupSvidUser2').val(hdYear);
            $('#hdPopupYear2').val(hdYear);
            $('#hdPopupMonth2').val(hdMonth);
            $('#hdPopupCompNo2').val(hdCompNo);
            $('#hdPopupUniqueNo2').val(hdUniqueNo);
            $('#hdPopupCompCode2').val(hdCompCode);
            $('#hdPopupAreaCode2').val(hdAreaCode);
            $('#hdPopupBdeptCode2').val(hdBdeptCode);
            $('#hdPopupdeptCode2').val(hdDeptCode);
            $('#hdPopupBudgetCost2').val(hdBudgetCost);
            $('#hdPopupRemainCost2').val(hdRemainCost);
            $('#hdPopupSvidUser2').val(hdSvidUser);

            var currentCost = $(el).parent().find('#hdBudgetCost2').val();
            $('#tdPopupUser').text('<%= UserInfoObject.Name%>');
            $('#<%= txtPopupBudget.ClientID%>').val(currentCost);
            var e = document.getElementById('modifyDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
        }

        //팝업 닫기
        function fnClosePopup(type) {
            if (type == 'View') {
                $('#modifyReasonDiv').fadeOut();
            }
            else {
                $('#modifyDiv').fadeOut();
            }
        }


        //메인 예산 리스트 페이징 전환
        function getPageData() {

            $('#tblBudgetInfo tbody').empty(); //디테일테이블 클리어
            $('#tblBudgetInfo tbody').append('<tr><td colspan="9" class="txt-center">조회된 데이터가 없습니다.</td></tr>');

            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnBudgetListBind(getPageNum);
            return false;
        }


        //팝업 예산 변경 리스트 페이지 전환
        function getPopupPageData() {

            var container = $('#popuppagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnModifyReasonListBind(getPageNum);
            return false;
        }

        //메인 예산 리스트 검색 버튼
        function fnSearch() {
            $('#tblBudgetInfo tbody').empty(); //디테일테이블 클리어
            $('#tblBudgetInfo tbody').append('<tr><td colspan="9" class="txt-center">조회된 데이터가 없습니다.</td></tr>');
            fnBudgetListBind(1);

        }

        //메인 검색창 엔터 이벤트
        function fnEnter() {

            if (event.keyCode == 13) {
                fnBudgetListBind(1);
                return false;
            }
            else
                return true;
        }

        //팝업 검색창 엔터 이벤트
        function fnPopupEnter() {
            if (event.keyCode == 13) {
                fnModifyReasonListBind(1);
                return false;
            }
            else
                return true;
        }

        var is_sending = false;


        //예산 변경 저장
        function fnSave() {
            var currentCost = $('#hdPopupBudgetCost2').val();
            var remainCost = $('#hdPopupRemainCost2').val();

            if ($('#<%= txtPopupBudget.ClientID%>').val() == '') {
                alert('예산을 입력해 주세요');
                $('#txtPopupBudget').focus();
                return false;

            }
            if ($('#<%= txtPopupRemark.ClientID%>').val() == '') {
                alert('변경이유를 입력해 주세요');
                $('#<%= txtPopupRemark.ClientID%>').focus();
                return false;

            }
            if ((parseInt(remainCost) - (parseInt(currentCost) - parseInt($('#<%= txtPopupBudget.ClientID%>').val()))) < 0) {
                alert('예산 수정시 잔여예산이 (-)마이너스가 됩니다.시스템 관리자에게 문의하여주시기 바랍니다.');
                return false;
            }

            var callback = function (response) {
                if (response == 'Success') {
                    alert('변경되었습니다.');
                }
                else {
                    alert('시스템 오류입니다. 개발팀에 문의하세요.');
                }
                return false;
            };
            var sUser = '<%=Svid_User %>';
            //alert($('#hdPopupCompCode2').val());
            var param = {
                SvidUser: $('#hdPopupSvidUser2').val(),
                MSvidUser: sUser,
                Method: 'UpdateBudget',
                Year: $('#hdPopupYear2').val(),
                Month: $('#hdPopupMonth2').val(),
                CompNo: $('#hdPopupCompNo2').val(),
                UniqueNo: $('#hdPopupUniqueNo2').val(),
                CompCode: $('#hdPopupCompCode2').val(),
                CompAreaCode: $('#hdPopupAreaCode2').val(),
                CompBDeptCode: $('#hdPopupBdeptCode2').val(),
                CompDeptCode: $('#hdPopupdeptCode2').val(),
                Cost: $('#<%= txtPopupBudget.ClientID%>').val(),
                Remark: $('#<%= txtPopupRemark.ClientID%>').val(),
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                $('#modifyDiv').fadeOut();
                fnBudgetListBind(1);
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'text', callback, beforeSend, complete, true, sUser);
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "BAM":
                    window.location.href = "../Company/BudgetAccountMain?ucode=" + ucode;
                    break;
                case "BM":
                    window.location.href = "../Company/BudgetMain?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }


        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="sub-contents-div">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                구매사 예산관리
                    <span class="span-title-subsentence"></span>
            </p>
        </div>
        <div>
            <br />
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="예산계정관리" onclick="fnGoPage('BAM')" />
        </div>
        <!--탭메뉴-->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BudgetMain');">
                    <a onclick="fnTabClickRedirect('BudgetMain');">구매사 예산조회</a>
                </li>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BudgetRegister');">
                    <a onclick="fnTabClickRedirect('BudgetRegister');">구매사 예산등록</a>
                </li>
            </ul>
        </div>


        <!--상단 조회 영역 시작-->
        <div class="search-div">


            <div class="bottom-search-div">
                <table class="notice-search-table" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2;">
                    <tr style="height: 30px;">
                        <th style="width: 50%">
                            <select id="select1" class="input-text" style="width: 180px">
                                <option value="Code">구매사 회사코드</option>
                                <option value="Name">구매사 회사명</option>
                            </select>
                            <input type="text" id="txtKeyword1" style="width: 400px" onkeypress="return fnEnter();" />
                        </th>
                        <th>
                            <select id="select2" class="input-text" style="width: 180px">
                                <option value="Code">구매사 사업장코드</option>
                                <option value="Name">구매사 사업장명</option>
                            </select>
                            <input type="text" id="txtKeyword2" style="width: 400px" onkeypress="return fnEnter();" />
                        </th>

                    </tr>
                    <tr>
                        <th>
                            <select id="select3" class="input-text" style="width: 180px">
                                <option value="Code">구매사 사업부코드</option>
                                <option value="Name">구매사 사업부명</option>
                            </select>
                            <input type="text" id="txtKeyword3" style="width: 400px" onkeypress="return fnEnter();" />
                        </th>
                        <th>
                            <select id="select4" class="input-text" style="width: 180px">
                                <option value="Code">구매사 부서코드</option>
                                <option value="Name">구매사 부서명</option>
                            </select>
                            <input type="text" id="txtKeyword4" style="width: 400px" onkeypress="return fnEnter();" />
                        </th>
                    </tr>
                </table>

            </div>
            <div class="bt-align-div" style="margin-top: 20px;">
                <asp:Button runat="server" Text="검색" CssClass="mainbtn type1" OnClientClick="fnSearch(); return false;" Style="width: 75px; height: 25px;" />
            </div>
            <div class="fileDiv" style="margin-bottom: 30px; height: 30px;">

                <table class="fileTbl">
                    <tr>
                        <th>엑셀파일 등록</th>
                        <td>
                            <asp:FileUpload runat="server" ID="fuExcel" CssClass="excelfileupload" /></td>
                        <td style="border-right: none;">
                            <asp:Button ID="ibtnExcelUpload" Text="엑셀업로드" runat="server" OnClick="ibtnExcelUpload_Click" CssClass="mainbtn type1" Style="width: 90px; height: 25px;" /></td>
                        <td style="border-left: none;">
                            <asp:Button ID="ibtnExcelFormDownload" Text="엑셀업로드폼 다운로드" runat="server" OnClick="ibtnExcelFormDownload_Click" CssClass="mainbtn type1" Style="width: 180px; height: 25px;" /></td>
                    </tr>
                </table>

            </div>
        </div>
        <%--검색창 끝--%>
        <br />
        <%-- 리스트 시작 --%>
        <div class="list-table" style="clear: both">

            <table class="tbl_main" id="tblBudgetList" style="margin-top: 0">
                <colgroup>
                    <col style="width: 5%;" />
                    <!--선택-->
                    <col style="width: 6%;" />
                    <!--번호-->
                    <col style="width: 7%;" />
                    <!--년도-->
                    <col style="width: 5%;" />
                    <!--월-->
                    <col style="width: 17%;" />
                    <!--구매사 회사코드/구매사 명-->
                    <col style="width: 17%;" />
                    <!--구매사 사업장코드/구매사 사업자 명-->
                    <col style="width: 17%;" />
                    <!--구매사 사업부 코드/구매사 사업부 명-->
                    <col style="width: 17%;" />
                    <!--구매사 부서코드/ 구매사 부서명-->
                </colgroup>
                <thead>
                    <tr>
                        <th class='txt-center' rowspan="2">선택</th>
                        <th class='txt-center' rowspan="2">번호</th>
                        <th class='txt-center' rowspan="2">년도</th>
                        <th class='txt-center' rowspan="2">월</th>
                        <th class='txt-center'>구매사 회사코드</th>
                        <th class='txt-center'>구매사 사업장코드</th>
                        <th class='txt-center'>구매사 사업부코드</th>
                        <th class='txt-center'>구매사 부서코드</th>
                    </tr>
                    <tr>
                        <th class='txt-center'>구매사 회사명</th>
                        <th class='txt-center'>구매사 사업장명</th>
                        <th class='txt-center'>구매사 사업부명</th>
                        <th class='txt-center'>구매사 부서명</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
            <br />
            <input type="hidden" id="hdTotalCount" />
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!-- 페이징 처리 -->

        </div>

        <br />
        <%-- 디테일  시작 --%>
        <div class="list-table" style="clear: both">
            <input type="hidden" id="hdDetailYear" />
            <input type="hidden" id="hdDetailMonth" />
            <input type="hidden" id="hdDetailCompNo" />
            <input type="hidden" id="hdDetailUniqueNo" />
            <input type="hidden" id="hdDetailCompCode" />
            <input type="hidden" id="hdDetailAreaCode" />
            <input type="hidden" id="hdDetailBdeptCode" />
            <input type="hidden" id="hdDetaildeptCode" />
            <input type="hidden" id="hdDetailModiUserName" />
            <input type="hidden" id="hdDetailUpdateDate" />
            <input type="hidden" id="hdDetailRemark" />
            <input type="hidden" id="hdDetailBudgetCost" />
            <input type="hidden" id="hdDetailBudgetCarriedCost" />
            <input type="hidden" id="hdDetailBudgetTotalCost" />
            <input type="hidden" id="hdDetailBudgetRemainCost" />
            <input type="hidden" id="hdDetailEntryDate" />
            <input type="hidden" id="hdDetailUserName" />
            <input type="hidden" id="hdDetailSvidUser" />
            <table class="tbl_main" id="tblBudgetInfo">
                <colgroup>
                    <col style="width: 10%;" />
                    <col style="width: 7%;" />
                    <col style="width: 20%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 7%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th class='txt-center'>변경자</th>
                        <th class='txt-center'>변경날짜</th>
                        <th class='txt-center'>변경이유</th>
                        <th class='txt-center'>당월 예산금액</th>
                        <th class='txt-center'>이월 예산금액</th>
                        <th class='txt-center'>예산 총금액</th>
                        <th class='txt-center'>남은 예산금액</th>
                        <th class='txt-center'>등록자</th>
                        <th class='txt-center'>등록날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <tr id="trEmptyRow" style="text-align: center">
                        <td colspan="8" class="txt-center">조회된 데이터가 없습니다.</td>
                    </tr>
                </tbody>
            </table>

        </div>
        <%-- 디테일 끝 --%>
    </div>

    <%-- 변경이유 보기 팝업시작 --%>
    <div id="modifyReasonDiv" class="divpopup-layer-package">
        <div class="modifyReasonWrapper">
            <div class="modifyReasonContent" style="border: none;">
                <div class="divpopup-layer-container">
                    <div class="sub-title-div">
                        <img src="../Images/Member/mPop-title2.jpg" alt="변경 이력 조회" />

                        <button type="button" onclick="fnClosePopup('View'); return false;" class="close-bt" style="float: right">
                            <img src="../../Images/Wish/icon-delete.jpg" /></button>

                    </div>

                    <div class="divpopup-layer-conts">
                        <div>
                            <table id="tbl_main" style="width: 100%;">
                                <colgroup>
                                    <col style="width: 80px" />
                                    <col style="width: 250px" />
                                </colgroup>


                                <tr>
                                    <th class="txt-center" style="background-color: #ececec">조회기간</th>
                                    <td style="padding-left: 5px;">

                                        <input type="text" id="searchStartDate" class="searchDate" />&nbsp; - &nbsp;<input type="text" id="searchEndDate" class="searchDate" />&nbsp;&nbsp;&nbsp;
                                            <input type="checkbox" id="ckbSearch1" value="7" checked="checked" /><label for="ckbSearch1">7일</label>
                                        <input type="checkbox" id="ckbSearch2" value="15" /><label for="ckbSearch2">15일</label>
                                        <input type="checkbox" id="ckbSearch3" value="30" /><label for="ckbSearch3">30일</label>
                                    </td>


                                </tr>
                                <tr>
                                    <th class="txt-center" style="background-color: #ececec">변경자명</th>
                                    <td class="txt-center">
                                        <input type="text" id="txtPopupSearch" style="width: 98%" class="inputContents" onkeypress="return fnPopupEnter();" placeholder="변경자명을 입력하세요" />
                                    </td>
                                </tr>
                            </table>
                            <div class="btn1" style="margin-bottom: 15px; margin-top: 5px; float: right">
                                <a>
                                    <img src="../Images/Order/search-off.jpg" alt="검색" onclick="fnModifyReasonListBind(1); return false;" onmouseover="this.src='../Images/Order/search-on.jpg'" onmouseout="this.src='../Images/Order/search-off.jpg'" id="ibtnSearchPopup" /></a>
                                <input type="hidden" id="hdPopupYear" />
                                <input type="hidden" id="hdPopupMonth" />
                                <input type="hidden" id="hdPopupCompNo" />
                                <input type="hidden" id="hdPopupUniqueNo" />
                                <input type="hidden" id="hdPopupCompCode" />
                                <input type="hidden" id="hdPopupAreaCode" />
                                <input type="hidden" id="hdPopupBdeptCode" />
                                <input type="hidden" id="hdPopupdeptCode" />
                                <input type="hidden" id="hdPopupSvidUser" />
                            </div>

                        </div>
                        <br />
                        <div class="divModifyList" style="clear: both">
                            <table id="tblModifyList" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="txt-center" style="width: 30px">순번</th>
                                        <th class="txt-center" style="width: 50px">변경자</th>
                                        <th class="txt-center" style="width: 50px">변경날짜</th>
                                        <th class="txt-center" style="width: 300px">변경이유</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                        <br />
                        <input type="hidden" id="hdModifyTotalCount" />
                        <div style="margin: 0 auto; text-align: center">
                            <div id="popuppagination" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- 변경이유 보기 팝업끝 --%>


    <%-- 예산 변경 팝업시작 --%>
    <div id="modifyDiv" class="divpopup-layer-package">
        <div class="modifyWrapper">
            <div class="modifyContent" style="border: none;">
                <div class="divpopup-layer-container">
                    <div class="sub-title-div">
                        <img src="../Images/Company/bPOP-title.jpg" alt="예산 변경" />
                        <button type="button" onclick="fnClosePopup('Modify'); return false;" class="close-bt" style="float: right">
                            <img src="../../Images/Wish/icon-delete.jpg" /></button>

                    </div>

                    <div class="divpopup-layer-conts">
                        <table style="width: 100%" id="tblModify">
                            <tr class="board-tr-height">
                                <th class="txt-center" style="width: 100px">변경자</th>
                                <td class="txt-center" style="width: 100px" id="tdPopupUser"></td>
                            </tr>
                            <tr class="board-tr-height">
                                <th class="txt-center" style="width: 100px">당월예산금액</th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:TextBox runat="server" ID="txtPopupBudget" Width="100%" Height="24px" Style="border: 1px solid #a2a2a2" onkeypress="return onlyNumbers(event);"></asp:TextBox>
                                </td>

                            </tr>
                            <tr class="board-tr-height">
                                <th class="txt-center" style="width: 100px">변경이유</th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:TextBox runat="server" ID="txtPopupRemark" Rows="5" onkeypress="preventEnter(event)" TextMode="MultiLine" Width="100%"></asp:TextBox>
                                </td>

                            </tr>
                        </table>
                        <br />
                        <div style="text-align: right; margin-top: 20px;">
                            <input type="hidden" id="hdPopupSvidUser2" />
                            <input type="hidden" id="hdPopupYear2" />
                            <input type="hidden" id="hdPopupMonth2" />
                            <input type="hidden" id="hdPopupCompNo2" />
                            <input type="hidden" id="hdPopupUniqueNo2" />
                            <input type="hidden" id="hdPopupCompCode2" />
                            <input type="hidden" id="hdPopupAreaCode2" />
                            <input type="hidden" id="hdPopupBdeptCode2" />
                            <input type="hidden" id="hdPopupdeptCode2" />
                            <input type="hidden" id="hdPopupRemainCost2" />
                            <input type="hidden" id="hdPopupBudgetCost2" />
                            <input type="hidden" id="hdSvidUser2" />
                            <img id="ibtnSave" alt="저장" src="../Images/Order/save.jpg" onmouseover="this.src='../Images/Order/save-on.jpg'" onmouseout="this.src='../Images/Order/save.jpg'" onclick="return fnSave();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- 예산 변경 팝업끝 --%>
</asp:Content>

