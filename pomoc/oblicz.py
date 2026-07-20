import tkinter as tk

def oblicz():
    try:
        szer = float(entry_szer.get())
        pred = float(entry_pred.get())
        wsp  = float(entry_wsp.get())
        baza_spalanie_h = float(entry_spalanie.get())
        masa_narzedzia = float(entry_masa.get())

        """
        Gwarantujemy, że baza to absolutne minimum. 
        Gdyby ktoś wpisał ujemną masę lub dziwne wartości,
        program nie zejdzie poniżej spalania bazowego.
        """
        
        """
        Urealnienie oporu polowego:
        1. Opór od masy: ok. 1.2 l/h na każdą tonę (opór toczenia i dźwigania).
        2. Opór roboczy gleby: zależny od szerokości roboczej i prędkości 
           (narzędzie wyciąga z silnika dodatkowe litry na każdy metr szerokości).
        3. Szacowany poślizg kół w polu (ok. 10%, czyli mnożnik 1.10 do obciążenia).
        """
        opor_masy = (max(0.0, masa_narzedzia) / 1000.0) * 1.2
        opor_roboczy = szer * (pred / 8.0) * 1.5
        poslizg_mnoznik = 1.10

        dodatkowe_spalanie = (opor_masy + opor_roboczy) * poslizg_mnoznik
        
        """ Realne spalanie godzinowe to baza + wyliczone obciążenie polowe """
        realne_spalanie_h = max(baza_spalanie_h, baza_spalanie_h + dodatkowe_spalanie)

        """
        Obliczanie wydajności powierzchniowej (ha/h)
        Zgodnie ze standardowym wzorem agrotechnicznym.
        """
        wydajnosc = (szer * pred * wsp) / 10.0
        
        """
        Obliczanie zużycia paliwa na hektar (l/ha).
        Jeżeli parametry będą zerowe, wydajność wyniesie 0. 
        Zabezpieczamy się, żeby nie zwalić koncertowo dzielenia przez zero.
        """
        if wydajnosc > 0:
            spalanie_ha = realne_spalanie_h / wydajnosc
            label_paliwo.config(text=f"Zużycie paliwa: {spalanie_ha:.2f} l/ha (chwilowe: {realne_spalanie_h:.1f} l/h)")
        else:
            label_paliwo.config(text="Zużycie paliwa: błąd (wydajność = 0)")

        label_wynik.config(text=f"Wydajność: {wydajnosc:.2f} ha/h")
        
    except ValueError:
        label_wynik.config(text="Błąd danych!")
        label_paliwo.config(text="Zużycie paliwa: ---")

root = tk.Tk()
root.title("Wydajność i Spalanie")

tk.Label(root, text="Szerokość [m]:").grid(row=0, column=0)
entry_szer = tk.Entry(root)
entry_szer.grid(row=0, column=1)

tk.Label(root, text="Prędkość [km/h]:").grid(row=1, column=0)
entry_pred = tk.Entry(root)
entry_pred.grid(row=1, column=1)

tk.Label(root, text="Współczynnik wykorzystania czasu (0.6–0.8):").grid(row=2, column=0)
entry_wsp = tk.Entry(root)
entry_wsp.grid(row=2, column=1)

tk.Label(root, text="Minimalne spalanie bazowe [l/h]:").grid(row=3, column=0)
entry_spalanie = tk.Entry(root)
entry_spalanie.grid(row=3, column=1)

tk.Label(root, text="Masa narzędzia [kg]:").grid(row=4, column=0)
entry_masa = tk.Entry(root)
entry_masa.grid(row=4, column=1)

tk.Button(root, text="Oblicz", command=oblicz).grid(row=5, column=0, columnspan=2)

label_wynik = tk.Label(root, text="Wydajność: ---")
label_wynik.grid(row=6, column=0, columnspan=2)

label_paliwo = tk.Label(root, text="Zużycie paliwa: ---")
label_paliwo.grid(row=7, column=0, columnspan=2)

root.mainloop()