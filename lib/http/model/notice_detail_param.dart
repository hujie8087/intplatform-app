///知识体系传递给明细页面参数
class NoticeDetailParam{

  String? noticeTitle;
  String? noticeId;

  NoticeDetailParam(this.noticeTitle, this.noticeId);

  @override
  String toString() {
    return 'NoticeDetailParam{noticeTitle: $noticeTitle, noticeId: $noticeId}';
  }
}
