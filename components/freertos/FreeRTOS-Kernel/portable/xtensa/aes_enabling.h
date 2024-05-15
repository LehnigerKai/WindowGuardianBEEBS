#include "soc/dport_reg.h"
#include "soc/dport_access.h"

extern void aes_registers();
extern void aes_registers(){
_DPORT_REG_SET_BIT(DPORT_PERI_CLK_EN_REG, DPORT_PERI_EN_AES);
_DPORT_REG_CLR_BIT(DPORT_PERI_RST_EN_REG, (DPORT_PERI_EN_AES | DPORT_PERI_EN_DIGITAL_SIGNATURE | DPORT_PERI_EN_SECUREBOOT));
}
