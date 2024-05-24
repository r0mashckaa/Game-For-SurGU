<script lang="ts">
        function perehod1() {
            window.location.replace('/');
        }
</script>

<div class="container">
    <button on:click={perehod1} class="chngpage">Игра</button>
    <div class="bestiary">
		<h1 class="head">БЕСТИАРИЙ</h1>
        <div class="obj">
            <div class="osn">
				<img src="player.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 3<pre /><b>Способности: </b><pre /> Капкан - ставит под себя капкан, при наступание на который, мобы, кроме призрака получают урон; цена - 3 кристалла.<pre />Динамит - взрывается, нанося урон всем вокруг героя, включая его самого; цена - 5 кристаллов. 
			</div>
			<div class="discription"><b>Рон</b> все детство мечтал о приключениях, но был рожден в семье фермеров. Каждый день был для него пыткой. Пока однажды он не решился на побег. У него все сошло с рук и он начал своое странсстиве. В одном из трактиров, он встретил опытного воина, который рассказал, что некоторые люди готовы платить за головы вампиров. У Рона загорелись глаза, он уговорил воина обучить его владению меча. С тех пор прошло немало времени, уже всему обученный Рон путешествует по миру и охотится на вампиров, убивая другую нечисть, что повстречается у него на пути. В одном из таких приключений он находит таинственный замок, который не смог обойти стороной...</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="knight.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 1<pre /><b>Способности: </b><pre /> Ходят каждый ход.<pre /> Станится после удара по игроку.
			</div>
			<div class="discription"><b>Рыцари</b> в замке служили королеве, пока та не повстречалась с волшебником, оживляющий трупы. Она хотела вернуть к жизни короля, который пал в одной из битв. Волшебник потребовал взамен отдать ему царство, на что королева, всё обдумав, согласилась. Волшебник выполнил свою часть сделки, но воскресший король уже не был человеком, он был грудой ходящих костей, которая и слова произнести не может. Королева, осознавшая что её обманули, попыталась убить волшебника. Она взяла недалеко стоявший канделябр и подожгла волшебника. Волшебник хохотал, пока его кожа полностью не обгорела. Подумав, что все кончено, королева хотела уйти, пока не почувствовала, что за ногу её кто-то схватил. Это был тот волшебник, он тоже стал скелетом. С тех пор рыцари уже пару столетий служат новому королю.</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="necromant.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 2<pre /><b>Способности: </b><pre />Раз в пять ходов призывает скелета.<pre />При получении урона телепортируется.
			</div>
			<div class="discription"><b>Некроманта</b> нашли пьяницы у входа в трактир во время очень сильной грозы и приютили. Мальчишка с самого детства вел себя хуже всех в трактире. В один момент всем надоело его терпеть и его выгнали из деревни. Он сбежал и поселился на кладбище, где вскоре обнаружил свою волшебную способность - воскрешать мертвых людей в виде скелетов, которые сразу же подчинялись его власти. Ходя по деревням и сжигая их, он пополнял свою армию, но его жажда власти не утихала. Некромант обманул королеву, правящую в его царстве, и заполучил все земли королевства.</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="skelet.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 1<pre /><b>Способности: </b><pre />Ходят раз в два хода.
			</div>
			<div class="discription"><b>Скелеты</b> призываются некромантом и служат ему. Ходят слухи, что среди них всё ещё находятся бывшие король и королева замка.</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="golem.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 3<pre /><b>Способности: </b><pre />Ходит раз в два хода.
			</div>
			<div class="discription"><b>Големы</b> давно служили королевству. Они не только были надежной защитой, но и помогали строить дома. Пока к власти не пришел некромант.</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="ghost.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 1<pre /><b>Способности: </b><pre />Ходит каждый ход.<pre />Может проходить сквозь стены.<pre />Может активировать капкан не получа урона.
			</div>
			<div class="discription">jfdlfljdkasdljfklfjak fsjklf;jfsdkl;fjfskl;fsdjfla;jsdkl;sjfdkl;sjfdklsj;fksldja ;jfklsa;jfkl;j sdklfjsd;fsd fkjskjff fsd fkjsjfd ksfkssjfdkfjsf fjk dkjfk fdskjsf sfkjsfdkfj fdjkdf jfjdkf dkf fjkfd fdjkfjfd fdjk fdjkfd jlk;f</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="slime.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 1<pre /><b>Способности: </b><pre />Ходит каждый ход.<pre />Выпрыгивает из вазы.<pre />
			</div>
			<div class="discription">jfdlfljdkasdljfklfjak fsjklf;jfsdkl;fjfskl;fsdjfla;jsdkl;sjfdkl;sjfdklsj;fksldja ;jfklsa;jfkl;j sdklfjsd;fsd fkjskjff fsd fkjsjfd ksfkssjfdkfjsf fjk dkjfk fdskjsf sfkjsfdkfj fdjkdf jfjdkf dkf fjkfd fdjkfjfd fdjk fdjkfd jlk;f</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="barrel.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 1<pre /><b>Способности: </b><pre />Ходит каждый ход.<pre />Взрывается когда подходит к игроку или умирает.
			</div>
			<div class="discription">jfdlfljdkasdljfklfjak fsjklf;jfsdkl;fjfskl;fsdjfla;jsdkl;sjfdkl;sjfdklsj;fksldja ;jfklsa;jfkl;j sdklfjsd;fsd fkjskjff fsd fkjsjfd ksfkssjfdkfjsf fjk dkjfk fdskjsf sfkjsfdkfj fdjkdf jfjdkf dkf fjkfd fdjkfjfd fdjk fdjkfd jlk;f</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="vampire.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> 1<pre /><b>Способности: </b><pre />Ходит каждый ход.<pre />Каждые семь ходов перевоплощается в летучую мышь и обратно, причем летучая мышь ходит раз в два хода, и её нельзя ударить.
			</div>
			<div class="discription">jfdlfljdkasdljfklfjak fsjklf;jfsdkl;fjfskl;fsdjfla;jsdkl;sjfdkl;sjfdklsj;fksldja ;jfklsa;jfkl;j sdklfjsd;fsd fkjskjff fsd fkjsjfd ksfkssjfdkfjsf fjk dkjfk fdskjsf sfkjsfdkfj fdjkdf jfjdkf dkf fjkfd fdjkfjfd fdjk fdjkfd jlk;f</div>
        </div>
		<div class="obj">
            <div class="osn">
				<img src="armor.png" alt="" class="osn_ikon" />
				<h4 class="osn_txt"><b>HP: </b> ထ<pre /><b>Способности: </b><pre />Ходит раз в два хода.<pre />Бессмертен, живет до конца волны.
			</div>
			<div class="discription">jfdlfljdkasdljfklfjak fsjklf;jfsdkl;fjfskl;fsdjfla;jsdkl;sjfdkl;sjfdklsj;fksldja ;jfklsa;jfkl;j sdklfjsd;fsd fkjskjff fsd fkjsjfd ksfkssjfdkfjsf fjk dkjfk fdskjsf sfkjsfdkfj fdjkdf jfjdkf dkf fjkfd fdjkfjfd fdjk fdjkfd jlk;f</div>
        </div>
    </div>
</div>

<style>
    .container {
		display: flex;
		flex-direction: column;
		margin: 295px auto 0;
		width: 820px;
	}
    .chngpage {
		margin-left: 20px;
		color: #836409;
		font-size: 23px;
		text-decoration: none;
		position: relative;
		width: 45px;
		background: none;
		border: none;
		cursor: url('sword.png'), auto;
	}
	.chngpage:after {
		display: block;
		position: absolute;
		content: '';
		width: 0;
		height: 2px;
		background: #836409;
		transition: 0.3s;
		left: 60%;
		transform: translateX(-41%);
	}
	.chngpage:hover:after {
		width: 110%;
	}
	.bestiary {
		margin: 40px auto 0;
		width: 700px;
	}
	.head {
		color: #990030;
		padding: 10px 248px;
	}
	.obj {
		border-top: 6px solid #990030;
		border-bottom:  4px solid #990030;

	}
	.osn {
		display: inline-flex;
		height: 140px;
	}
	.osn_ikon {
		padding: 10px;
		margin: 10px;
		width: 128px;
		height: 128px;
		border: 4px solid #990030;
	}
	.osn_txt {
		margin: 13px 20px;
		padding: auto 0;
	}
	.discription {
		margin: 20px 30px;
	}
</style>