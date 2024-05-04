<script lang="ts">
	function perehod() {
		window.location.replace('/heroes');
	}
</script>

<div class="container">
	<button on:click={perehod} class="chngpage">Бестиарий</button>
	<img src="ff.png" alt="" class="ffa" />
	<div class="text">
		<h3>Управление:</h3>
		<h3>W/↑ - идти/атаковать вверх; <b class="kgk">A/← - идти/атаковать влево;</b></h3>
		<h3>
			S/↓ - идти/атаковать вниз; <b class="kgk">&nbsp&nbsp&nbsp D/→ - идти/атаковать вправо;</b>
		</h3>
		<h3>1 - Капкан; <b class="kgk1">2 - Динамит</b></h3>
	</div>
	<div class="line" />
	<div class="description">
		<h2>Описание:</h2>
		<h4>опоппопоопопопопппопоопопоппоооооооооооооо оооооооооооооооооооооооооооо оооооооооооооооррпрррпр рпррпррррооаооаолд ыаволдаодлывжоавылджывоылджао авылдажоа лджоыв лдажоалдыжаовлы жавоыл дажоылджаоылджа оыладжыовлдаывжоалд ывжоалдыжыоылоа ыаоыаыоаылд аыоыалдао аыо длыо ы  ылдолдодлоа аолдаолды аолыджаоылдажо ыоа оаылыджавоыав аыволджа оылаы жолыджы авоаылджаы воалдыж аывоал ао аыоалыд жоыв дывоаыл аоыо оа о ао адывавоылджа ыволд ыоаывыавджоы</h4>
	</div>
</div>

<style>
	.container {
		display: flex;
		flex-direction: column;
		margin: 295px auto 0;
		max-width: 820px;
	}
	.chngpage {
		margin-left: 700px;
		color: #836409;
		font-size: 23px;
		text-decoration: none;
		position: relative;
		width: 104px;
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
		transform: translateX(-50%);
	}
	.chngpage:hover:after {
		width: 110%;
	}
	.ffa {
		margin: 60px 0 20px;
		border: 18px solid #ffc20e;
	}
	.text {
		margin: 10px auto 0;
		padding: 0 17px 0 17px;
		border: 6px solid #ffc20e;
	}
	.kgk {
		padding-left: 60px;
	}
	.kgk1 {
		padding-left: 210px;
	}
	.line {
		margin: 20px 0 20px 0;
		border: 2px solid #ffc20e;
	}
	.description {
		margin: 0 50px 0 50px;
	}
</style>
