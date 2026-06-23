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

## Fajlovi na routeru

```
/file print
```
