Imports System.IO
Imports System.Xml
Imports System.Text
Imports DotNetNuke.Entities.Portals

Namespace DotNetNuke.Modules.Events

    Partial Class EventRssSocial
        Inherits System.Web.UI.Page


#Region "Private Variables"
        Private _moduleId As Integer
        Private _tabId As Integer
        Private _portalId As Integer
        Private _settings As EventModuleSettings


#End Region


        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

            If Not HttpContext.Current.Request.QueryString("Mid") = "" Then
                _moduleId = CType(HttpContext.Current.Request.QueryString("mid"), Integer)
            Else
                Response.Redirect(NavigateURL(), True)
            End If
            If Not HttpContext.Current.Request.QueryString("tabid") = "" Then
                _tabId = CType(HttpContext.Current.Request.QueryString("tabid"), Integer)
            Else
                Response.Redirect(NavigateURL(), True)
            End If

            Dim portalSettings As PortalSettings = CType(HttpContext.Current.Items("PortalSettings"), PortalSettings)
            _portalId = portalSettings.PortalId
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8

            Dim sw As StringWriter = New StringWriter
            Dim writer As XmlTextWriter = New XmlTextWriter(sw)
            writer.Formatting = Formatting.Indented
            writer.Indentation = 4

            writer.WriteStartElement("rss")
            writer.WriteAttributeString("version", "2.0")
            writer.WriteAttributeString("xmlns:wfw", "http://wellformedweb.org/CommentAPI/")
            writer.WriteAttributeString("xmlns:slash", "http://purl.org/rss/1.0/modules/slash/")
            writer.WriteAttributeString("xmlns:dc", "http://purl.org/dc/elements/1.1/")
            writer.WriteAttributeString("xmlns:trackback", "http://madskills.com/public/xml/rss/module/trackback/")
            writer.WriteAttributeString("xmlns:atom", "http://www.w3.org/2005/Atom")

            writer.WriteStartElement("channel")

            writer.WriteStartElement("atom:link")
            writer.WriteAttributeString("href", HttpContext.Current.Request.Url.AbsoluteUri)
            writer.WriteAttributeString("rel", "self")
            writer.WriteAttributeString("type", "application/rss+xml")
            writer.WriteEndElement()

            writer.WriteElementString("title", portalSettings.PortalName & " - Future Events")

            If (portalSettings.PortalAlias.HTTPAlias.IndexOf("http://") = -1) Then
                writer.WriteElementString("link", "http://" & portalSettings.PortalAlias.HTTPAlias)
            Else
                writer.WriteElementString("link", portalSettings.PortalAlias.HTTPAlias)
            End If

            writer.WriteElementString("description", "List of future events that occur 28, 7 and 1 days from today.")
            writer.WriteElementString("ttl", "60")

            Dim localResourceFile As String = TemplateSourceDirectory & "/" & Localization.LocalResourceDirectory & "/EventRSS.aspx.resx"
            Dim ems As New EventModuleSettings
            _settings = ems.GetEventModuleSettings(_moduleId, localResourceFile)


            Dim objEventInfoHelper As New EventInfoHelper(_moduleId, _tabId, _portalId, _settings)
            Dim lstEvents As ArrayList
            lstEvents = objEventInfoHelper.GetEvents(Date.Now, Date.Now.AddDays(35), False, "")

            Dim objEvent As EventInfo
            For Each objEvent In lstEvents
                Dim daystoevent As Int32 = objEvent.EventDateBegin.Date.Subtract(Date.Now).Days
                If daystoevent <> 28 AndAlso daystoevent <> 7 AndAlso daystoevent <> 1 Then
                    Continue For
                End If

                writer.WriteStartElement("item")

                Dim strdateinfo As String

                Dim dtEndDate2 As Date = objEvent.EventDateBegin.AddMinutes(objEvent.Duration)

                If (objEvent.EventDateBegin.Day = dtEndDate2.Day) Then

                    strdateinfo = objEvent.EventDateBegin.ToString("MMM dd, yyyy")
                Else
                    strdateinfo = objEvent.EventDateBegin.ToString("MMM dd-") + dtEndDate2.ToString("dd, yyyy")
                End If


                Dim eventTitle As String = objEvent.EventName + " - " + strdateinfo
                writer.WriteElementString("title", eventTitle)

                'Dim txtDescription As String = StripTags(HttpUtility.HtmlDecode(objEvent.EventDesc)).Replace("&nbsp;", "")

                'If txtDescription.Length > 600 Then
                '    txtDescription = txtDescription.Substring(0, 599) + "..."
                'End If

                writer.WriteElementString("description", HttpUtility.HtmlDecode(objEvent.EventDesc))

                Dim txtURL As String = objEventInfoHelper.DetailPageURL(objEvent)
                writer.WriteElementString("link", txtURL)
                writer.WriteElementString("guid", txtURL)

                Dim pubDate As DateTime = Convert.ToDateTime(Date.Now.ToShortDateString() + " 06:00:00")

                writer.WriteElementString("pubDate", pubDate.ToUniversalTime().ToString("r"))

                writer.WriteElementString("dc:creator", objEvent.OwnerName)

                If objEvent.Category > 0 And Not IsNothing(objEvent.Category) Then
                    writer.WriteElementString("category", objEvent.CategoryName)
                End If
                If objEvent.Location > 0 And Not IsNothing(objEvent.Location) Then
                    writer.WriteElementString("location", objEvent.LocationName)
                End If
                writer.WriteEndElement()
            Next

            writer.WriteEndElement()
            writer.WriteEndElement()

            Response.Write(sw.ToString)
        End Sub

        Public Function StripTags(ByVal html As String) As String
            ' Removes tags from passed HTML
            Return RegularExpressions.Regex.Replace(html, "<[^>]*>", "")
        End Function

        Public Function AddSkinContainerControls(ByVal url As String, ByVal addchar As String, ByVal settings As EventModuleSettings) As String
            Dim objEventInfoHelper As New EventInfoHelper(_moduleId, _tabId, _portalId, Settings)
            Return objEventInfoHelper.AddSkinContainerControls(url, addchar)
        End Function
    End Class
End Namespace