# MikroTik SSH komande - brza referenca

## Konekcija

```bash
ssh admin@<ip-routera>
```

## Praćenje loga

```
/log print follow where topics~"warning|error|info"
```

## Skripta

```
# Ručno pokretanje
/system script run lte-watchdog

# Pregled svih skripti
/system script print
```

## Scheduler

```
# Pregled schedulera
/system scheduler print

# Detalji (start-time, interval)
/system scheduler print detail
```

## Testiranje scenarija

```
# Simuliraj 2 uzastopna pada - trigeruje restart modema
:set lteFailCount 2
/system script run lte-watchdog

# Simuliraj 3 restarta modema - trigeruje reboot rutera (pazi!)
:set lteRestartCount 3
/system script run lte-watchdog

# Reset brojača
:set lteFailCount 0
:set lteRestartCount 0
```

## Cell lock (ručno, kada si na lokaciji)

```
# Provera trenutne ćelije (earfcn, phy-cellid, signal)
/interface lte info lte1 once

# Zaključavanje na ćeliju - upiši trenutni phy-cellid
/interface lte at-chat lte1 input="AT+GTCELLLOCK=1,0,0,1795,<phy-cellid>"

# Primer: phy-cellid=327
/interface lte at-chat lte1 input="AT+GTCELLLOCK=1,0,0,1795,327"

# Uklanjanje locka
/interface lte at-chat lte1 input="AT+GTCELLLOCK=0,0,0,0,0"

# Provera stanja locka
/interface lte at-chat lte1 input="AT+GTCELLLOCK?"
```

Napomena: EARFCN 1795 = B3@20MHz (dobra ćelija). EARFCN 1651 = B3@10MHz (loša ćelija, izbegavati).

## Fajlovi na routeru

```
/file print
```
