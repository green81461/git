<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CompanyMap.aspx.cs" MasterPageFile="~/Master/Default.master" Inherits="Other_CompanyMap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script charset="UTF-8" class="daum_roughmap_loader_script" src="http://dmaps.daum.net/map_js_init/roughmapLoader.js"></script>
    <script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>
    <style>
        .root_daum_roughmap .wrap_btn_zoom {
            display: none;
        }
    </style>
    <script>
        var daumcodeTS;
        var daumcodeKey;
        $(function () {

            $('#s_address').text(saleCompAdress);
            if (!isEmpty(daumMapCode)) {
                daumcodeTS = daumMapCode.split(',')[0];
                daumcodeKey = daumMapCode.split(',')[1];

                $('#daumRoughmapContainer').attr('id', 'daumRoughmapContainer' + daumcodeTS);
            }

            if ($('.wrap_map').length == 0) {
                searchLoad(daumcodeTS, daumcodeKey);
            }

        })

        function searchLoad(timestamp, key) {
            //제이쿼리로 초기화
            new daum.roughmap.Lander({
                "timestamp": timestamp,
                "key": key,
                "mapWidth": "1254",
                "mapHeight": "600"
            }).render();

        }

    </script>

    <link href="../Content/other/faq.css" rel="stylesheet" />
    <link href="../Content/sub.css" rel="stylesheet" />

    <div class="sub-contents-div">
        <div class="sub-title-div">
             <img src="/images/CompanyMap.png" />
        </div>


        <div class="div-compabout-content" id="divMainContent">
            <div class="tab-content">
                <div id="daumRoughmapContainer" class="root_daum_roughmap root_daum_roughmap_landing"></div>
                <div style="margin-top: 20px; margin-bottom: 20px; margin-left: 20px; height: auto; text-align: left; overflow: hidden">
                    <b>찾아오시는 길 : <strong id="s_address"></strong></b>
                </div>
            </div>
        </div>

        <div class="left-menu-wrap" id="divLeftMenu">
            <dl>
                <dt style="border-bottom: 1px solid #eaeaea;">
                    <strong>회사소개</strong>
                </dt>
                <dd>
                    <a href="/Other/CompanyAbout">인사말</a>
                </dd>
                <dd>
                    <a>사업소개</a><%--href="/Other/BusinessIntroduction"--%>
                </dd>
                <dd class="active">
                    <a href="/Other/CompanyMap.aspx">오시는 길</a>
                </dd>
            </dl>
        </div>
    </div>
</asp:Content>
