import { LightningElement, api } from 'lwc';

export default class VideoPlayer extends LightningElement {

    @api videoUrl;

    @api isPlaying(){
        const player = this.template.querySelector('video');
        return player !== null && player.paused === false;
    }

    @api 
    play(){
        const player = this.template.querySelector('video');
         if(player){
            player.play();
         }
    }
    @api
    pause(){
      const player  = this.template.querySelector('video');
      if(player){
        player.pause();
     }   
    
    }

    // private method for computed value
    get videoType() {
        return 'video/' + this.videoUrl.split('.').pop();
    }

    @api
     newmethod(){
        alert('calling parent methods inchild');
     }
}