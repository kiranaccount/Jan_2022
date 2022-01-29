({ 
    
    doInit : function(cmp){
        cmp.set("v.setMeOnInit","controller init magic!");
       
    },
    dailypartices : function(){    
        // partice ES6
        let firstname='test',lastname = "anitha Gugulothu",age = 20;
        // creating constant
        let reference1 = firstname;
        const temp = 15.5,name = 'Daily';
        console.log('reference=====>'+reference1);
        console.log(lastname);
        console.log(age);
        console.log(temp);
        console.log(name);
        
        let test1= 'I am going to home,"kodad"';
        console.log(test1);  
        // string Escaping 
        let test2 = "i am going to home,\"dont\'t go to home\"";
        console.log(test2);  
        let cal = 2*'10';
        let cal2 = cal *20; 
        console.log(cal2);
        
        let ans = 3;
        
        switch(ans){
            case 1:
                console.log('i like java');
                break;
            case 2:
                console.log('i like AI');
                break;
            case 3:
                console.log('i like ML');
                break;
            case 4:
                console.log('i like EST');
                break;
            case 5:
                console.log('ans is incorrenct');
                break;
        }
        let a =0;
        
        while(a<10){
            console.log(a);
            a++;
        }
        
    },
    distructingArg : function (cmp){
        let name = 'kiran';
        const ar = ["daily","i am going to","offic"];
        cmp.set("v.distructingArg",ar[1]);         
       var a= cmp.get("v.distructingArg");
       console.log(a);        
    }
    
})