class Checkin::DiscoursePoster
  DIFFCULTY = %w(太简单 容易 适中 难 太难)
  TIME_COST = %w(1小时以内 1小时 2小时 3小时 4小时 4小时以上)

  attr_reader :checkin, :lesson

  def initialize(checkin)
    @checkin = checkin
    @lesson = checkin.lesson
  end

  def api
    @api ||= Checkin::DiscourseAPI.new
  end

  def publish
    topic_id = lesson.discourse_topic_id
    user_name = checkin.enrollment.user.authentications.github[0].info["nickname"]

    if checkin.published?
      api.update_post(checkin.discourse_post_id, user_name, raw_post)
    else
      post = api.create_post(topic_id, user_name, raw_post)
      checkin.discourse_post_id = post["id"]
      checkin.save
    end
 end

  private

  def raw_post
    post = <<-THERE
+ Repo: [#{checkin.github_repository}](#{checkin.github_repository})
+ 耗时: #{TIME_COST[checkin.time_cost]}
+ 难度: #{DIFFCULTY[checkin.degree_of_difficulty]}

+ 课程遇到的问题和解决方法:
#{checkin.problem}
THERE
  end

end
