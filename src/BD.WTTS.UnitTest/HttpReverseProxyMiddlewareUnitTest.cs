namespace BD.WTTS.UnitTest;

public sealed class HttpReverseProxyMiddlewareUnitTest
{
    [SetUp]
    public void Setup()
    {
    }

    /// <summary>
    /// 测试查找脚本注入位置
    /// </summary>
    [Test]
    public void TestFindScriptInjectInsertPosition()
    {
        var buffer = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta charset="utf-8">
            <title></title>
            </head>
            <body>
            <h1>xxxx</h1>
            <p>yyyy</p>
            </body>
            </html>
            """u8;

        var encoding = Encoding.UTF8;
        HttpReverseProxyMiddleware.FindScriptInjectInsertPosition(buffer.ToArray(), encoding, out var _, out var position);
        Assert.That(position, Is.GreaterThan(0));

        var html_start = buffer[..position];
        var script_xml_start = "<script type=\"text/javascript\" src=\"/.watt-toolkit-inject/"u8.ToArray();
        var script_xml_end = ".js\"></script>"u8.ToArray();

        using var s = new MemoryStream();
        s.Write(html_start);
        s.Write(script_xml_start);
        s.Write(encoding.GetBytes("1"));
        s.Write(script_xml_end);
        var html_end = buffer[position..];
        s.Write(html_end);

        var new_html = encoding.GetString(s.ToArray());
        TestContext.WriteLine(new_html);
    }

    [Test]
    public void TestFindScriptInjectInsertPositionForGithub_BeforeLastScript()
    {
        var html = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta charset="utf-8">
            <title>demo</title>
            </head>
            <body>
            <script src="/first.js"></script>
            <script src="/runtime.js"></script>
            </body>
            </html>
            """;

        var buffer = Encoding.UTF8.GetBytes(html);
        var ok = HttpReverseProxyMiddleware.FindScriptInjectInsertPositionForGithub(buffer, Encoding.UTF8, out _, out var position);

        Assert.That(ok, Is.True);
        var expected = html.LastIndexOf("<script src=\"/runtime.js\">", StringComparison.OrdinalIgnoreCase);
        Assert.That(position, Is.EqualTo(expected));
    }

    [Test]
    public void TestFindScriptInjectInsertPositionForGithub_BeforeLastScriptWithSrc()
    {
        var html = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta charset="utf-8">
            </head>
            <body>
            <script src="/first.js"></script>
            <script>window.__INLINE__ = true;</script>
            <script src="/runtime.js" data-rspack="@github-ui/github-ui:runtime"></script>
            <script>window.__AFTER_RUNTIME__ = true;</script>
            </body>
            </html>
            """;

        var buffer = Encoding.UTF8.GetBytes(html);
        var ok = HttpReverseProxyMiddleware.FindScriptInjectInsertPositionForGithub(buffer, Encoding.UTF8, out _, out var position);

        Assert.That(ok, Is.True);
        var expected = html.LastIndexOf("<script src=\"/runtime.js\"", StringComparison.OrdinalIgnoreCase);
        Assert.That(position, Is.EqualTo(expected));
    }
}