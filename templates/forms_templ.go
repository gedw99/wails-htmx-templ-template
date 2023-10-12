// Code generated by templ@v0.2.364 DO NOT EDIT.

package components

//lint:file-ignore SA4006 This context is only used if a nested component is present.

import "github.com/a-h/templ"
import "context"
import "io"
import "bytes"

import "net/http"
import "fmt"

import types "wailstest/types"

func Pages(index types.IndexForm) templ.Component {
	return templ.ComponentFunc(func(ctx context.Context, w io.Writer) (err error) {
		templBuffer, templIsBuffer := w.(*bytes.Buffer)
		if !templIsBuffer {
			templBuffer = templ.GetBuffer()
			defer templ.ReleaseBuffer(templBuffer)
		}
		ctx = templ.InitializeContext(ctx)
		var_1 := templ.GetChildren(ctx)
		if var_1 == nil {
			var_1 = templ.NopComponent
		}
		ctx = templ.ClearChildren(ctx)
		for _, i := range index.Pages {
			_, err = templBuffer.WriteString("<li hx-boost hx-get=\"")
			if err != nil {
				return err
			}
			_, err = templBuffer.WriteString(templ.EscapeString(i.Path))
			if err != nil {
				return err
			}
			_, err = templBuffer.WriteString("\" hx-target=\"#target-form\" hx-swap=\"innerHTML transition:true\"><a class=\"font-medium text-2xl\">")
			if err != nil {
				return err
			}
			var var_2 string = i.Label
			_, err = templBuffer.WriteString(templ.EscapeString(var_2))
			if err != nil {
				return err
			}
			_, err = templBuffer.WriteString("</a></li>")
			if err != nil {
				return err
			}
		}
		err = VersionComponent(index.Version).Render(ctx, templBuffer)
		if err != nil {
			return err
		}
		if !templIsBuffer {
			_, err = templBuffer.WriteTo(w)
		}
		return err
	})
}

func GreetForm(endpoint string, target string, label string) templ.Component {
	return templ.ComponentFunc(func(ctx context.Context, w io.Writer) (err error) {
		templBuffer, templIsBuffer := w.(*bytes.Buffer)
		if !templIsBuffer {
			templBuffer = templ.GetBuffer()
			defer templ.ReleaseBuffer(templBuffer)
		}
		ctx = templ.InitializeContext(ctx)
		var_3 := templ.GetChildren(ctx)
		if var_3 == nil {
			var_3 = templ.NopComponent
		}
		ctx = templ.ClearChildren(ctx)
		_, err = templBuffer.WriteString("<div class=\"result\" id=\"result\">")
		if err != nil {
			return err
		}
		var_4 := `Please enter your name below 👇`
		_, err = templBuffer.WriteString(var_4)
		if err != nil {
			return err
		}
		_, err = templBuffer.WriteString("</div>")
		if err != nil {
			return err
		}
		err = TextInput("name", "Enter Name").Render(ctx, templBuffer)
		if err != nil {
			return err
		}
		err = Button("", endpoint, target, label).Render(ctx, templBuffer)
		if err != nil {
			return err
		}
		if !templIsBuffer {
			_, err = templBuffer.WriteTo(w)
		}
		return err
	})
}

func Greet(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("HX-Reswap", "innerHTML")
	w.Write([]byte(fmt.Sprintf("Hello %s, It's show time!", r.FormValue("name"))))
	return
}