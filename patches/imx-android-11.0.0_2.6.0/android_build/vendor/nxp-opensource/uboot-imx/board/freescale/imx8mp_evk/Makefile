#
# Copyright 2019 NXP
#
# SPDX-License-Identifier:      GPL-2.0+
#

obj-y += imx8mp_evk.o

ifdef CONFIG_SPL_BUILD
obj-y += spl.o
#obj-$(CONFIG_IMX8M_LPDDR4) += lpddr4_timing.o
obj-$(CONFIG_IMX8M_LPDDR4) += lpddr4_timing_MT53D512M32D2DS-053_WTD_1500MHz.o
#obj-$(CONFIG_IMX8M_LPDDR4) += lpddr4_timing_MT53D1024M32D4DT-053_WTD_1500MHz.o
obj-$(CONFIG_IMX8M_DDR4) += ddr4_timing.o
endif
