import { LightningElement } from 'lwc';
export default class CarouselExample extends LightningElement {

        contacts = [
        {
            Id: 1,
            Name: 'Amy Taylor',
            Title: 'VP of Engineering',
        },
        {
            Id: 2,
            Name: 'Michael Jones',
            Title: 'VP of Sales',
        },
        {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
        {
            Id: 4,
            Name: 'Jennifer Wu1',
            Title: 'CEO1',
        },
        {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
         {
            Id: 3,
            Name: 'Jennifer Wu',
            Title: 'CEO',
        },
    ];
      clickedButtonLabel;

   handleClick(event) {
        this.clickedButtonLabel = event.target.label;
        alert(event.target.label);
        const date = new Date(2020,11,10);
        const datadisplayopt ={
            year: 'numeric',
            month: 'long',
            day: 'numeric'

        };

        const formateddate = date.toLocaleDateString('en',datadisplayopt);
        console.log('formateddate--->'+formateddate);
       // alert(JSON.stringify('formateddate--->'+formateddate));

        let foodmean1  =['pizza','Burger','french fries'];
        let foodmean = foodmean1;
        foodmean.push('garlic bread');
        //alert(JSON.stringify('foodmean1--->'+foodmean1));

        const books = {
            titel:'javaScript',
        };
        Object.preventExtensions(books);
        const newobje = books;
        newobje.author = 'kiran';
        console.log(newobje);
        console.log(books);
        //alert(JSON.stringify('books--->'+books));
        //alert(JSON.stringify('newobje--->'+newobje));

        
    }
}