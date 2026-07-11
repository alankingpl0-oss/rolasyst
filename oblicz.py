import tkinter as tk

def oblicz():
    try:
        szer = float(entry_szer.get())
        pred = float(entry_pred.get())
        wsp  = float(entry_wsp.get())

        wynik = (szer * pred * wsp) / 10
        label_wynik.config(text=f"Wydajność: {wynik:.2f} ha/h")
    except ValueError:
        label_wynik.config(text="Błąd danych!")

root = tk.Tk()
root.title("Wydajność na hektar")

tk.Label(root, text="Szerokość [m]:").grid(row=0, column=0)
entry_szer = tk.Entry(root)
entry_szer.grid(row=0, column=1)

tk.Label(root, text="Prędkość [km/h]:").grid(row=1, column=0)
entry_pred = tk.Entry(root)
entry_pred.grid(row=1, column=1)

tk.Label(root, text="Współczynnik (0.6–0.8):").grid(row=2, column=0)
entry_wsp = tk.Entry(root)
entry_wsp.grid(row=2, column=1)

tk.Button(root, text="Oblicz", command=oblicz).grid(row=3, column=0, columnspan=2)

label_wynik = tk.Label(root, text="Wydajność: ---")
label_wynik.grid(row=4, column=0, columnspan=2)

root.mainloop()
