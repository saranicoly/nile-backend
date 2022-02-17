class MonthlyReportController < ApplicationController
    require 'prawn'

    def index
        generate_pdf(data.length, 12)
        redirect_to '/monthly_report.pdf'
    end

    private

    def data
        firestore = firebase_connection
        measured_data = firestore.col "device_data"

        return measured_data.get.map { |measure| measure.data }.sort_by { |measure| measure[:datetime] }
    end

    def generate_pdf(measures_qtd, days_qtd)
        Prawn::Document.new(pdf_options = {:page_size => "A4", :page_layout => :portrait, :margin => [40, 75]}) do |pdf|
            # Define a cor do traçado
            pdf.fill_color "666666"
            # Cria um texto com tamanho 30 PDF Points, bold alinha no centro
            pdf.text "Monthly Report", :size => 32, :style => :bold, :align => :center
            # Move 60 PDF points para baixo o cursor
            pdf.move_down 60         
            # draw bullet point
            pdf.text_box "*", :size => 32, :style => :bold, :align => :left, :at => [0, pdf.cursor]
            pdf.text_box "Last month, your fish tank data was measured #{measures_qtd} times.", :size => 14, :style => :bold, :at => [30, pdf.cursor]
            pdf.move_down 30
            pdf.text_box "*", :size => 32, :style => :bold, :align => :left, :at => [0, pdf.cursor]
            pdf.text_box "Nile was able to collect your fish tank data for #{days_qtd} days in the last month.", :size => 14, :style => :bold, :at => [30, pdf.cursor]
            pdf.move_down 140
            pdf.stroke do
                pdf.rectangle [0, pdf.cursor], 180, 180
                pdf.rectangle [250, pdf.cursor], 180, 180
                pdf.move_down 280
                pdf.rectangle [0, pdf.cursor], 180, 180
                pdf.rectangle [250, pdf.cursor], 180, 180
            end
            pdf.draw_text "Temperature", :size => 14, :style => :bold, :at => [50, 225]
            pdf.text_box "* The temperature of your tank is stable", :size => 14, :at => [10, 190], :width => 140, :align => :justify
            pdf.draw_text "PH", :size => 14, :style => :bold, :at => [322, 225]
            pdf.text_box "* The PH of your tank is stable", :size => 14, :at => [260, 190], :width => 140, :align => :justify
            pdf.draw_text "Dissolved Oxygen", :size => 14, :style => :bold, :at => [32, 505]
            pdf.text_box "* You should take a look on the dissolved oxygen levels. Your fishes may not have oxygen enough to live.", :size => 14, :at => [10, 470], :width => 140, :align => :justify
            pdf.draw_text "Turbidity", :size => 14, :style => :bold, :at => [309, 505]
            pdf.text_box "* The turbidity of your tank is stable", :size => 14, :at => [260, 470], :width => 140, :align => :justify
            # Inclui em baixo da folha do lado direito a data e o némero da página usando a tag page
            pdf.number_pages "Generated: #{(Time.now).strftime("%d/%m/%y at %H:%M")}", :page_filter => :all, :at => [pdf.bounds.right - 140, 7], :align => :right, :size => 8
            # Gera no nosso PDF e coloca na pasta public com o nome agreement.pdf
            pdf.render_file('public/monthly_report.pdf')
        end
    end
end