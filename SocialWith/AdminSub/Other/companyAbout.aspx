<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="companyAbout.aspx.cs" Inherits="AdminSub_Other_companyAbout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

	<script charset="UTF-8" class="daum_roughmap_loader_script" src="http://dmaps.daum.net/map_js_init/roughmapLoader.js"></script>


    <script>
        function openNewWindow(){
            window.open("https://get.adobe.com/reader/?loc=kr");
        }

    </script>


    <link href="../../Content/other/faq.css" rel="stylesheet" />
	
	<div style="border:1px solid #fff; width:1262px; height:auto;">

		 <div class="sub-contents-div" style="margin-top:0">
			
             <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회사소개
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
             <div style="height:30px;"></div>
			<asp:HiddenField runat="server" ID="hfTabNum" />

			<dl id="tabmenu" style="margin-top: -10px;">
				<dt class="tab_btn11"><a href="#" id="aTabBtn1">
					<img src="../Images/Other/companyAbout-tab-on.jpg" alt="인사말" title="인사말" /></a></dt>
				<dd>
					<div class="tab-content">
						<img src="../Images/Other/intro-pic2.jpg" />
					</div>
				</dd>

				<!-- CI소개 탭-->
				<dt class="tab_btn22"><a href="#" id="aTabBtn2">
					<img src="../Images/Other/companyAbout-tab2-off.jpg" alt="CI소개" title="CI소개" /></a></dt>
				<dd id="ciDiv" class="tab-display">
					<div class="tab-ci-content">
						<div class="mini-title">
							<img src="../Images/Other/ci-minititle.jpg" alt="symbol" title="symbol" />
						</div>
						<img src="../Images/Other/ci-pic.jpg" />
						<div class="color">
							<img class="title" src="../Images/Other/ci-minititle2.jpg" alt="color" title="color" />
							<img src="../Images/Other/color-content.jpg" alt="color안 컨텐츠입니다" />
						</div>
						<div class="download">
							<img class="title" src="../Images/Other/ci-download3.jpg" alt="download" title="download" />
							<ul>
								<li>
									<asp:ImageButton ID="pdfButton" runat="server" OnClick="pdfButton_Click" ImageUrl="../Images/Other/pdfDown-off.jpg" onmouseover="this.src='../Images/Other/pdfDown-on.jpg'" onmouseout="this.src='../Images/Other/pdfDown-off.jpg'" />
							</li>
								<li>
									<div style="height: 20px;"></div>
								</li>
								<li>
									<asp:ImageButton ID="imgButton" runat="server" OnClick="imgButton_Click" ImageUrl="../Images/Other/ci-download2.jpg" onmouseover="this.src='../Images/Other/jpegDown-on.jpg'" onmouseout="this.src='../Images/Other/ci-download2.jpg'" /></li>
									 <li>
									<div style="height: 20px;"></div>
								</li>
								<li>
					  <a  onclick="openNewWindow()"><img src="/AdminSub/Images/Other/Acrobat-off.jpg" onmouseover="this.src='/AdminSub/Images/Other/Acrobat-on.jpg'" onmouseout="this.src='/AdminSub/Images/Other/Acrobat-off.jpg'" /></a>
								 
								</li>
							</ul>
						</div>
					
			   
					
					</div>
				</dd>
			
			
			
			
				<!-- 사업소개 탭-->
				<dt class="tab_btn33"><a href="#" id="aTabBtn3">
					<img src="../Images/Other/companyAbout-tab3-off.jpg" alt="사업소개" title="사업소개" /></a></dt>
				<dd id="businessDiv" class="tab-display">
					<div class="tab-business-content">
						<img src="../Images/Other/introduce-pic3-2.jpg" />
					</div>
				</dd>

				<!-- 찾아오시는길 탭-->
				<dt class="tab_btn44">
					<a href="#" id="aTabBtn4" onclick="searchLoad();">
						<img src="../Images/Other/companyAbout-tab4-off.jpg" alt="찾아오시는길" title="찾아오시는길" /></a>
				</dt>
				<dd id="wayDiv" class="tab-display">
					<div class="tab-content">
						<div id="daumRoughmapContainer1510186126214" class="root_daum_roughmap root_daum_roughmap_landing"></div>

						<div style="margin-top: 20px; margin-bottom: 20px; margin-left: 20px; height: auto; text-align: left; overflow: hidden">

							<b>찾아오시는 길 : 서울시 금천구 벚꽃로 18길 15 ( 지번 : 금천구 독산동 1000-16) </b>
							<br />



						</div>
					</div>


				</dd>
			</dl>
		 </div>
	</div>


	<script charset="UTF-8">
        function searchLoad() {
            //제이쿼리로 초기화
            $("#daumRoughmapContainer1510186126214").html('');
            new daum.roughmap.Lander({
                "timestamp": "1510186126214",
                "key": "kdtu",
                "mapWidth": "1218",
                "mapHeight": "600"
            }).render();

        }

    </script>



    <script type="text/javascript">
        
        $(function () {

            fnSetDocReadyTap(); // 페이지 로딩 시 탭 설정

            var onTab = $("#tabmenu dt a:first");

            $("#tabmenu dt a").on("mouseclick focus click", function () {
                $("#tabmenu dd:visible").hide();

                $("a[id^='aTabBtn'] img").each(function () {
                    $(this).attr("src", $(this).attr("src").replace("on.jpg", "off.jpg"));
                });
                
                //$("img", onTab).attr("src", $("img", onTab).attr("src").replace("on.jpg", "off.jpg"));
                $(this).parent().next().show();
                $("img", this).attr("src", $("img", this).attr("src").replace("off.jpg", "on.jpg"));

                onTab = $(this);
                return false;
            });
        });

        // 페이지 로딩 시 탭 설정
        function fnSetDocReadyTap() {
            $("a[id^='aTabBtn'] img").each(function () {
                $(this).attr("src", $(this).attr("src").replace("on.jpg", "off.jpg"));
            });

            $("#tabmenu dd").hide();

            var tabNum = $("#" + '<%=hfTabNum.ClientID %>').val();

            $("#aTabBtn" + tabNum + " img").attr("src", $("#aTabBtn" + tabNum + " img").attr("src").replace("off.jpg", "on.jpg"));
            $("#tabmenu dd:eq(" + (tabNum - 1) + ")").show();

            if (tabNum == "4") {
                searchLoad();
            }
        }

    </script>

</asp:Content>

