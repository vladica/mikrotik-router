# ============================================================
# LTE Watchdog skripta - MikroTik SXT LTE6 / Fibocom FG621-EA
# Verzija: 2026-06-23
# Izmene u odnosu na prethodnu verziju:
#   - /interface lte disable/enable zamenjeno sa AT+CFUN=1,1
#     jer disable/enable ne resetuje interno stanje modema
#   - Cell lock uklonjen - A1 Srbija cesto menja cell ID
# ============================================================

:global lteFailCount;
:global lteRestartCount;
:if ([:typeof $lteFailCount] = "nothing") do={
    :set lteFailCount 0
}
:if ([:typeof $lteRestartCount] = "nothing") do={
    :set lteRestartCount 0
}

# Provera 1: da li lte1 ima IP adresu
:local lteIP "";
:do {
    :set lteIP [/ip address get [find interface="lte1"] address];
} on-error={}
:if ([:len $lteIP] = 0) do={
    :log warning "LTE no IP address, restarting modem via AT+CFUN";
    /interface lte at-chat lte1 input="AT+CFUN=1,1";
    :delay 30s;
    :set lteFailCount 0;
    :set lteRestartCount ($lteRestartCount + 1);
    :if ($lteRestartCount >= 3) do={
        :log error "Reboot router - LTE no IP after 3 restarts";
        :set lteRestartCount 0;
        :delay 5;
        /system reboot;
    }
    :error "LTE had no IP, modem restarted";
}

# Provera 2: ping test kroz 3 hosta
:local ok1 0
:local ok2 0
:local ok3 0
:do { :set ok1 ([/ping 8.8.8.8 count=2 interface=lte1 as-value]->"received") } on-error={}
:do { :set ok2 ([/ping 1.1.1.1 count=2 interface=lte1 as-value]->"received") } on-error={}
:do { :set ok3 ([/ping 9.9.9.9 count=2 interface=lte1 as-value]->"received") } on-error={}

:if (($ok1 + $ok2 + $ok3) = 0) do={
    :set lteFailCount ($lteFailCount + 1);
    :log warning ("LTE fail count=" . $lteFailCount);
} else={
    :if ($lteFailCount > 0) do={
        :log info "LTE RECOVERED"
    }
    :set lteFailCount 0;
    :set lteRestartCount 0;
}

# Restart modema posle 2 uzastopna pada (~6 min)
:if ($lteFailCount = 2) do={
    :set lteRestartCount ($lteRestartCount + 1);
    :log warning ("Restarting LTE modem via AT+CFUN, attempt=" . $lteRestartCount);
    /interface lte at-chat lte1 input="AT+CFUN=1,1";
    :delay 30s;
    :set lteFailCount 0;
}

# Reboot rutera posle 3 restarta modema (~18 min ukupno)
:if ($lteRestartCount >= 3) do={
    :log error "Reboot router - LTE stuck after 3 modem restarts";
    :set lteRestartCount 0;
    :set lteFailCount 0;
    :delay 5;
    /system reboot;
}
