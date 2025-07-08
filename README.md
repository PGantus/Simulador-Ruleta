# Simulador-Ruleta
Script en Bash para simular apuestas en ruleta usando las estrategias Martingala e Inverse Labouchere. Pensado para demostrar que la casa siempre gana y desincentivar las apuestas. Permite definir el dinero inicial, la técnica a usar y muestra resultados dinámicos con salida colorizada.

---

## ⚙️ Funcionalidades

- Estrategias:
  - **Martingala:** Duplicar la apuesta tras cada pérdida.
  - **Inverse Labouchere:** Ampliar o reducir secuencias de apuesta según resultados.
- Validaciones de entrada para evitar errores.
- Control de saldo y jugadas malas.
- Panel de ayuda con opciones.

---

## 📥 Descargar

```bash
git clone https://github.com/PGantus/Simulador-Ruleta.git
cd Simulador-Ruleta/
chmod +x ruleta.sh
```

---

## 🚀 Uso 

Ejemplo:
```bash
./ruleta.sh -m 100 -t Martingala
```

##### Parámetros:
-m: Monto de dinero inicial.
-t: Técnica a usar (Martingala o InverseLabrouchere).
-h: Mostrar panel de ayuda.
