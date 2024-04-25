const card = document.querySelector('.container')

card.addEventListener("mousemove", cardMoving)
card.addEventListener("mouseout", cardNatural)

function cardNatural(){
    card.style = 'none'
    card.transform.style = '2ms'
}

function cardMoving(event){

    const cardWidth = card.offsetWidth;
    const cardHeight = card.offsetHeight;
    const centerX = card.offsetLeft + cardWidth/2;
    const centerY = card.offsetTop + cardHeight/2;
    const positionX = event.clientX - centerX;
    const positionY = event.clientY - centerY;

    const rotateX = ((+1)*25*positionY/(cardHeight/2)).toFixed(2)
    const rotateY = ((-1)*25*positionX/(cardWidth/2)).toFixed(2)
    card.style.transform=`perspective(1500px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`

}
