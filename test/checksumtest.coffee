mocha = require 'mocha'
should = require 'should'

fs = require 'fs'

checksum = require '../lib/checksum'

describe 'Checksum', ->
  describe 'Success', ->
    before (done) ->
      base64 = 'iVBORw0KGgoAAAANSUhEUgAAAFAAAAAwCAYAAACG5f33AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAF01pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYxIDY0LjE0MDk0OSwgMjAxMC8xMi8wNy0xMDo1NzowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCBDUzUuMSBXaW5kb3dzIiB4bXA6Q3JlYXRlRGF0ZT0iMjAxMi0wOS0xNVQyMDowNzowMSswOTowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAxMi0wOS0xN1QxNDozNjowMiswOTowMCIgeG1wOk1vZGlmeURhdGU9IjIwMTItMDktMTdUMTQ6MzY6MDIrMDk6MDAiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjkxMTNCQTRFMDA4OTExRTI4NUNDOEUzNThENDM2QTEwIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjkxMTNCQTRGMDA4OTExRTI4NUNDOEUzNThENDM2QTEwIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6RTRCODU1MEUyNEZGRTExMThGQzZDOTEyMDdBMTEyQ0EiPiA8cGhvdG9zaG9wOlRleHRMYXllcnM+IDxyZGY6QmFnPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9Iuqyveq4sOqwgCDrk7HroZ0g65CY7JeI7Iq164uI64ukLiAgIOuniOydtOuqsOyXkOyEnCDqsr3quLAg7Iug7LKt64K07Jet7J2EIO2ZleyduO2VtOyjvOyEuOyalC4gICIgcGhvdG9zaG9wOkxheWVyVGV4dD0i6rK96riw6rCAIOuTseuhnSDrkJjsl4jsirXri4jri6QuICAg66eI7J2066qw7JeQ7IScIOqyveq4sCDsi6Dssq3rgrTsl63snYQg7ZmV7J247ZW07KO87IS47JqULiAgIi8+IDxyZGY6bGkgcGhvdG9zaG9wOkxheWVyTmFtZT0i7ZiE7J6sIOyKueyduCDrjIDquLDspJHsnoXri4jri6QuICDsirnsnbjsnbQg7JmE66OM65CY66m0IOydtOuplOydvOydhCDthrXtlbQg7JWM66Ck65Oc66a964uI64ukLiAgIiBwaG90b3Nob3A6TGF5ZXJUZXh0PSLtmITsnqwg7Iq57J24IOuMgOq4sOykkeyeheuLiOuLpC4gIOyKueyduOydtCDsmYTro4zrkJjrqbQg7J2066mU7J287J2EIO2Gte2VtCDslYzroKTrk5zrpr3ri4jri6QuICAiLz4gPHJkZjpsaSBwaG90b3Nob3A6TGF5ZXJOYW1lPSLqsJzstZzrkJwg6rK96riw6rCAIOyXhuyKteuLiOuLpC4gIOqyveq4sOulvCDsi6Dssq3tlbQg7KO87IS47JqULiAgIiBwaG90b3Nob3A6TGF5ZXJUZXh0PSLqsJzstZzrkJwg6rK96riw6rCAIOyXhuyKteuLiOuLpC4gIOqyveq4sOulvCDsi6Dssq3tlbQg7KO87IS47JqULiAgIi8+IDxyZGY6bGkgcGhvdG9zaG9wOkxheWVyTmFtZT0i7ZqM7JuQ6rCA7J6F7J20IOyZhOujjCDrkJjsl4jsirXri4jri6QuICDsgqzsmqnrsKnrspXsl5DshJwg7Jqw7YyM66Oo7YyMIOyCrOyaqeqwgOydtOuTnOulvCDtmZXsnbjtlZjsi6Ag7ZuEIOuniOydtOuqsOyXkOyEnCDsmrDtjIzro6jtjIzsnZgg7ISc67mE7Iqk66W8IOydtOyaqe2VtCIgcGhvdG9zaG9wOkxheWVyVGV4dD0i7ZqM7JuQ6rCA7J6F7J20IOyZhOujjCDrkJjsl4jsirXri4jri6QuICDsgqzsmqnrsKnrspXsl5DshJwg7Jqw7YyM66Oo7YyMIOyCrOyaqeqwgOydtOuTnOulvCDtmZXsnbjtlZjsi6Ag7ZuEIOuniOydtOuqsOyXkOyEnCDsmrDtjIzro6jtjIzsnZgg7ISc67mE7Iqk66W8IOydtOyaqe2VtCDrs7TshLjsmpQuICIvPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9IjLtmLjshKAiIHBob3Rvc2hvcDpMYXllclRleHQ9IjLtmLjshKAiLz4gPHJkZjpsaSBwaG90b3Nob3A6TGF5ZXJOYW1lPSIz67KI7Lac6rWsIiBwaG90b3Nob3A6TGF5ZXJUZXh0PSIzIi8+IDxyZGY6bGkgcGhvdG9zaG9wOkxheWVyTmFtZT0i6rWs66Gc65SU7KeA7YS464uo7KeA7JetIDPrsojstpzqtawiIHBob3Rvc2hvcDpMYXllclRleHQ9Iuq1rOuhnOuUlOyngO2EuOuLqOyngOyXrSAz67KI7Lac6rWsIi8+IDxyZGY6bGkgcGhvdG9zaG9wOkxheWVyTmFtZT0i64yA66a87JetIOuwqe2WpSIgcGhvdG9zaG9wOkxheWVyVGV4dD0i64yA66a87JetIOuwqe2WpSIvPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9IuyLoOuMgOuwqeyXrSDrsKntlqUiIHBob3Rvc2hvcDpMYXllclRleHQ9IuyLoOuMgOuwqeyXrSDrsKntlqUiLz4gPHJkZjpsaSBwaG90b3Nob3A6TGF5ZXJOYW1lPSLsi5ztnaUgSUMiIHBob3Rvc2hvcDpMYXllclRleHQ9IuyLnO2dpSBJQyIvPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9IuuCqOu2gOyInO2ZmOuhnCIgcGhvdG9zaG9wOkxheWVyVGV4dD0i64Ko67aA7Iic7ZmY66GcIi8+IDxyZGY6bGkgcGhvdG9zaG9wOkxheWVyTmFtZT0i6rO164uoNeqxsOumrCIgcGhvdG9zaG9wOkxheWVyVGV4dD0i6rO164uoNeqxsOumrCIvPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9IuyEnOyauO2KueuzhOyLnCDqtazroZzqtawg6rWs66Gc64+ZIDIyMi0xMiDrp4jrpqzsmKTtg4Dsm4wgODIw7Zi4ICAgICAgICAwNzAuNDMxMi4yNDY4ICAgICAgICAwMi4iIHBob3Rvc2hvcDpMYXllclRleHQ9IuyEnOyauO2KueuzhOyLnCDqtazroZzqtawg6rWs66Gc64+ZIDIyMi0xMiDrp4jrpqzsmKTtg4Dsm4wgODIw7Zi4ICAgICAgICAwNzAuNDMxMi4yNDY4ICAgICAgICAwMi44OTAuMDUyOSAgICAgICAgaW5mb0Bvb3Bhcm9vcGEuY29tICAy7Zi47ISgIOq1rOuhnOuUlOyngO2EuOuLqOyngOyXrSAz67KIIOy2nOq1rCDsgrDsl4XquLDsiKDsi5ztl5jsm5Ag67Cp7ZalIDMwME0iLz4gPHJkZjpsaSBwaG90b3Nob3A6TGF5ZXJOYW1lPSLso7zshowg66y47J2YICAgIOyngO2VmOyyoCIgcGhvdG9zaG9wOkxheWVyVGV4dD0i7KO87IaMIOusuOydmCAgICDsp4DtlZjssqAiLz4gPHJkZjpsaSBwaG90b3Nob3A6TGF5ZXJOYW1lPSLrp4jrpqzsmKTtg4Dsm4wgODIw7Zi4IiBwaG90b3Nob3A6TGF5ZXJUZXh0PSLrp4jrpqzsmKTtg4Dsm4wgODIw7Zi4Ii8+IDwvcmRmOkJhZz4gPC9waG90b3Nob3A6VGV4dExheWVycz4gPHBob3Rvc2hvcDpEb2N1bWVudEFuY2VzdG9ycz4gPHJkZjpCYWc+IDxyZGY6bGk+dXVpZDowOUUyODRENDQzMDRERDExODc3QzgzMTMzREJDNzczRDwvcmRmOmxpPiA8cmRmOmxpPnV1aWQ6QTBFQUQ2QTIyRTBDRTExMTk3M0NFRDA5MjVBNkU0QjQ8L3JkZjpsaT4gPHJkZjpsaT51dWlkOkE0RUFENkEyMkUwQ0UxMTE5NzNDRUQwOTI1QTZFNEI0PC9yZGY6bGk+IDxyZGY6bGk+dXVpZDpBRTk3REYxRDBGMjNFMTExOTFGQ0IyOUZEQUFFRDNEQjwvcmRmOmxpPiA8cmRmOmxpPnV1aWQ6QjEwNUMxRDNENEU3REYxMTk1RkM5NTc5Qzc4NUYxMTk8L3JkZjpsaT4gPHJkZjpsaT51dWlkOkI4MkEyMTVFOTBDMUUxMTE4RTRDOTY4Qjk0RjQ1MDA2PC9yZGY6bGk+IDxyZGY6bGk+dXVpZDpENTU0RDQ2ODg5RDRFMDExOTI4MkFCQTg4QzVGNTI4RjwvcmRmOmxpPiA8cmRmOmxpPnV1aWQ6RDhFNkMzQzIxMkIxRTExMUE1OTk5NTMwMDlGM0RCQUY8L3JkZjpsaT4gPHJkZjpsaT51dWlkOkRDODlDNDMxNjEyRURFMTFCRjg3QkFENEYyODY3MTNBPC9yZGY6bGk+IDxyZGY6bGk+eG1wLmRpZDoyOTQ3RDYwNjQwRTBFMTExQUIzNjhFNUYzOUYwMDc2MDwvcmRmOmxpPiA8cmRmOmxpPnhtcC5kaWQ6M0NGMEJGNkRENkYzRTAxMThDNzVFRUM1MjdBNUFFMzQ8L3JkZjpsaT4gPHJkZjpsaT54bXAuZGlkOjRFN0FCMjU5QTJERUUxMTE5NUI5OTkwNDg2RDdGMTVCPC9yZGY6bGk+IDxyZGY6bGk+eG1wLmRpZDo2NzVDQTM2REVCRTJFMTExQjM5NUQxRjQ0RjU0QjlCMjwvcmRmOmxpPiA8cmRmOmxpPnhtcC5kaWQ6NzVCMzlDNEMyMEU1RTExMUFENENBNjkyRDlFMDRCMzU8L3JkZjpsaT4gPHJkZjpsaT54bXAuZGlkOkFERDEwQTA3RDYxNzExRTE5NjA5QjgwRjVGMzZFMkY5PC9yZGY6bGk+IDxyZGY6bGk+eG1wLmRpZDpCODg1QUM5QUIxRDFFMTExODg0RDk0MUVCQUQ1OTYyQTwvcmRmOmxpPiA8cmRmOmxpPnhtcC5kaWQ6QkVGQjVERkQ1MUQxRTExMTg4NEQ5NDFFQkFENTk2MkE8L3JkZjpsaT4gPHJkZjpsaT54bXAuZGlkOkMyNDcyRjdGQkVERkUxMTFCMzhCOTRCRkYzREM4RkVGPC9yZGY6bGk+IDxyZGY6bGk+eG1wLmRpZDpEMkFDOUZCMEM1QjkxMUUxODM4OEU3RTEwMTM2QjkyRDwvcmRmOmxpPiA8cmRmOmxpPnhtcC5kaWQ6RUNDNjEzRkFFRUIzREYxMTk3MTdGMjNFRTBCMjg2MzU8L3JkZjpsaT4gPHJkZjpsaT54bXAuZGlkOkVFRjM4NTY4MzlFNEUwMTE5QjI5ODYyNDEzM0Q4MzdCPC9yZGY6bGk+IDxyZGY6bGk+eG1wLmRpZDpGNDQ5ODUwNEJDNDYxMUUxQjVFODgyM0RDMDc5REU1MzwvcmRmOmxpPiA8L3JkZjpCYWc+IDwvcGhvdG9zaG9wOkRvY3VtZW50QW5jZXN0b3JzPiA8eG1wTU06SGlzdG9yeT4gPHJkZjpTZXE+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJjcmVhdGVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOkU0Qjg1NTBFMjRGRkUxMTE4RkM2QzkxMjA3QTExMkNBIiBzdEV2dDp3aGVuPSIyMDEyLTA5LTE1VDIwOjA3OjAxKzA5OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ1M1LjEgV2luZG93cyIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6OTJBOEFFNDAyN0ZGRTExMThGQzZDOTEyMDdBMTEyQ0EiIHN0RXZ0OndoZW49IjIwMTItMDktMTVUMjA6MjA6MTMrMDk6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDUzUuMSBXaW5kb3dzIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo5NEE4QUU0MDI3RkZFMTExOEZDNkM5MTIwN0ExMTJDQSIgc3RFdnQ6d2hlbj0iMjAxMi0wOS0xNlQxMToyMDoyMiswOTowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIENTNS4xIFdpbmRvd3MiIHN0RXZ0OmNo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'
      buffer = new Buffer base64, 'base64'
      fs.writeFile 'image1.png', buffer, (err) ->
        done()
    it 'should create and return a checksum for a file', (done) ->
      filePath = './image1.png'
      checksum filePath, (err,checksum) ->
        should.not.exist err
        should.exist checksum
        checksum.should.equal '11ff3c92d5753d64a296b277fbbe5da1'
        done()
    after (done) ->
      fs.unlink 'image1.png', (err) ->
        done()


  describe 'Error handling', ->
    filePath = undefined
    it 'should return an error due to the file path being invalid', (done) ->
      checksum filePath, (err,checksum) ->
        should.exist err
        should.not.exist checksum
        done()