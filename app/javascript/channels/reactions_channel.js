import consumer from "channels/consumer"

consumer.subscriptions.create("ReactionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data);
    let like_panel = document.getElementById('likes')
    like_panel.innerHTML = `${data.total_likes}`

    let dislike_panel = document.getElementById('dislikes')
    dislike_panel.innerHTML = `${data.total_dislikes}`

    this.changeButtonColors(data)

  },

  changeButtonColors(data) {
    let current_user = document.getElementById('current_user_id').attributes['data'].value
    if(current_user != data.reacted_by) return;
    let upvote_button = document.getElementById('upvote_button')
    let downvote_button = document.getElementById('downvote_button')
    if(data.action == 'up_vote') {
      if(document.getElementById('upvote_button').classList.contains('btn-primary')) {
        upvote_button.classList.remove('btn-primary')
        upvote_button.classList.add('btn-light')
      }
      else if(document.getElementById('downvote_button').classList.contains('btn-danger')) {
        downvote_button.classList.remove('btn-danger')
        downvote_button.classList.add('btn-light')
        upvote_button.classList.remove('btn-light')
        upvote_button.classList.add('btn-primary')
      }
      else {
        upvote_button.classList.remove('btn-light')
        upvote_button.classList.add('btn-primary')
      }
    }
    else {
      if(document.getElementById('upvote_button').classList.contains('btn-primary')) {
        upvote_button.classList.remove('btn-primary')
        upvote_button.classList.add('btn-light')
        downvote_button.classList.remove('btn-light')
        downvote_button.classList.add('btn-danger')
      }
      else if(document.getElementById('downvote_button').classList.contains('btn-danger')) {
        downvote_button.classList.remove('btn-danger')
        downvote_button.classList.add('btn-light')
      }
      else {
        downvote_button.classList.remove('btn-light')
        downvote_button.classList.add('btn-danger')
      }
    }
  }
});
